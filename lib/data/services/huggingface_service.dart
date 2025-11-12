import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VirtualTryOnException implements Exception {
  final String message;
  final int? statusCode;
  VirtualTryOnException(this.message, [this.statusCode]);
  @override
  String toString() => 'VirtualTryOnException($statusCode): $message';
}

class VirtualTryOnService {
  final http.Client _client;
  final Uri _endpoint = Uri.parse(
    'https://api-inference.huggingface.co/models/ovi054/virtual-tryon-kontext-lora',
  );
  final int _maxRetries = 3;
  String? lastError;

  VirtualTryOnService({http.Client? client}) : _client = client ?? http.Client();

  Future<String?> generateTryOn(String personImageUrl, String clothImageUrl) async {
    try {
      final apiKey = dotenv.env['HUGGINGFACE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        lastError = 'Missing HUGGINGFACE_API_KEY';
        throw VirtualTryOnException(lastError!);
      }
      if (personImageUrl.isEmpty || clothImageUrl.isEmpty) {
        lastError = 'Input URLs must not be empty';
        throw VirtualTryOnException(lastError!);
      }

      if (!await _isValidImageUrl(personImageUrl)) {
        lastError = 'Invalid or inaccessible person image URL';
        return null;
      }
      if (!await _isValidImageUrl(clothImageUrl)) {
        lastError = 'Invalid or inaccessible cloth image URL';
        return null;
      }

      final payload = {
        'inputs': {
          'person_image_url': personImageUrl,
          'cloth_image_url': clothImageUrl,
        },
        'options': {
          'wait_for_model': true,
        },
      };

      http.Response? response;
      for (int attempt = 0; attempt < _maxRetries; attempt++) {
        try {
          response = await _client
              .post(
                _endpoint,
                headers: {
                  'Authorization': 'Bearer $apiKey',
                  'Content-Type': 'application/json',
                  'Accept': 'application/json, image/png, image/jpeg, application/octet-stream',
                  'x-wait-for-model': 'true',
                },
                body: jsonEncode(payload),
              )
              .timeout(const Duration(seconds: 90));

          if (response.statusCode >= 200 && response.statusCode < 300) {
            final contentType = response.headers['content-type'] ?? '';
            if (contentType.contains('application/json')) {
              final body = jsonDecode(utf8.decode(response.bodyBytes));
              if (body is Map<String, dynamic>) {
                final candidateKeys = ['image', 'generated_image', 'result', 'base64'];
                for (final key in candidateKeys) {
                  final value = body[key];
                  if (value is String && _looksLikeBase64(value)) {
                    await _cacheLastResult(value);
                    lastError = null;
                    return value;
                  }
                }
                final data = body['data'];
                if (data is List && data.isNotEmpty) {
                  final first = data.first;
                  if (first is Map) {
                    for (final key in candidateKeys) {
                      final v = first[key];
                      if (v is String && _looksLikeBase64(v)) {
                        await _cacheLastResult(v);
                        lastError = null;
                        return v;
                      }
                    }
                    final b64 = first['b64_json'];
                    if (b64 is String && _looksLikeBase64(b64)) {
                      await _cacheLastResult(b64);
                      lastError = null;
                      return b64;
                    }
                  }
                }
              }
              lastError = 'Empty or invalid JSON response';
              return null;
            } else {
              final b64 = base64Encode(response.bodyBytes);
              if (b64.isEmpty) {
                lastError = 'Empty image response';
                return null;
              }
              await _cacheLastResult(b64);
              lastError = null;
              return b64;
            }
          }

          // Handle retryable status codes
          if (response.statusCode == 503 || response.statusCode == 429) {
            await Future.delayed(Duration(milliseconds: 500 * (1 << attempt)));
            continue;
          } else {
            lastError = 'API error: ${response.statusCode}';
            return null;
          }
        } on TimeoutException {
          if (attempt == _maxRetries - 1) {
            lastError = 'Request timed out';
            return null;
          }
        } catch (e) {
          if (attempt == _maxRetries - 1) {
            lastError = 'Unexpected error: $e';
            return null;
          }
        }
      }

      lastError = 'Failed after retries';
      return null;
    } on TimeoutException {
      lastError = 'Request timed out';
      return null;
    } on VirtualTryOnException catch (e) {
      lastError = e.message;
      return null;
    } catch (e) {
      lastError = 'Unexpected error: $e';
      return null;
    }
  }

  static bool _looksLikeBase64(String s) {
    if (s.isEmpty) return false;
    if (s.length % 4 != 0) return false;
    final regex = RegExp(r'^[A-Za-z0-9+/=\r\n]+$');
    return regex.hasMatch(s);
  }

  Future<bool> _isValidImageUrl(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !(uri.isScheme('https') || uri.isScheme('http'))) {
        return false;
      }
      final head = await _client.head(uri).timeout(const Duration(seconds: 5));
      if (head.statusCode >= 200 && head.statusCode < 400) {
        final ct = head.headers['content-type'] ?? '';
        return ct.contains('image') || ct.contains('octet-stream');
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _cacheLastResult(String base64Image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_tryon_result_base64', base64Image);
    } catch (_) {
      // ignore cache errors
    }
  }

  static Future<String?> getLastCachedResult() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('last_tryon_result_base64');
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearCachedResult() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_tryon_result_base64');
    } catch (_) {
      // ignore
    }
  }

  void dispose() {
    _client.close();
  }
}
