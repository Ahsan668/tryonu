import '../models/clothing_item_model.dart';

/// ClothingRepository - Handles clothing catalog operations
class ClothingRepository {
  /// Get all clothing items (Mock data)
  Future<List<ClothingItemModel>> getAllClothingItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return _mockClothingItems;
  }
  
  /// Get clothing items by category
  Future<List<ClothingItemModel>> getClothingByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (category == 'All') {
      return _mockClothingItems;
    }
    
    return _mockClothingItems
        .where((item) => item.category == category)
        .toList();
  }
  
  /// Get clothing items by filter
  Future<List<ClothingItemModel>> getFilteredClothing({
    String? category,
    String? color,
    String? gender,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var items = _mockClothingItems;
    
    if (category != null && category != 'All') {
      items = items.where((item) => item.category == category).toList();
    }
    
    if (color != null && color != 'All') {
      items = items.where((item) => item.color == color).toList();
    }
    
    if (gender != null && gender != 'All') {
      items = items.where((item) => item.gender == gender).toList();
    }
    
    return items;
  }
  
  /// Get clothing item by ID
  Future<ClothingItemModel?> getClothingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      return _mockClothingItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Mock clothing data
  static final List<ClothingItemModel> _mockClothingItems = [
    // Shirts
    const ClothingItemModel(
      id: '1',
      name: 'Classic White Shirt',
      description: 'Premium cotton white shirt with modern fit',
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      category: 'Shirts',
      color: 'White',
      gender: 'Men',
      price: 49.99,
      brand: 'StyleCo',
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    const ClothingItemModel(
      id: '2',
      name: 'Denim Shirt',
      description: 'Casual denim shirt perfect for everyday wear',
      imageUrl: 'https://images.unsplash.com/photo-1603251578711-3290ca1a0187?w=400',
      category: 'Shirts',
      color: 'Blue',
      gender: 'Men',
      price: 59.99,
      brand: 'DenimWorks',
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    ),
    const ClothingItemModel(
      id: '3',
      name: 'Black T-Shirt',
      description: 'Essential black t-shirt made from organic cotton',
      imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=400',
      category: 'Shirts',
      color: 'Black',
      gender: 'Unisex',
      price: 29.99,
      brand: 'BasicTees',
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
    ),
    
    // Pants
    const ClothingItemModel(
      id: '4',
      name: 'Slim Fit Jeans',
      description: 'Dark wash slim fit jeans with stretch',
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      category: 'Pants',
      color: 'Blue',
      gender: 'Men',
      price: 79.99,
      brand: 'DenimWorks',
      sizes: ['28', '30', '32', '34', '36'],
    ),
    const ClothingItemModel(
      id: '5',
      name: 'Chinos',
      description: 'Comfortable chino pants for smart casual look',
      imageUrl: 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=400',
      category: 'Pants',
      color: 'Black',
      gender: 'Men',
      price: 69.99,
      brand: 'SmartWear',
      sizes: ['28', '30', '32', '34', '36'],
    ),
    
    // Dresses
    const ClothingItemModel(
      id: '6',
      name: 'Summer Floral Dress',
      description: 'Light and breezy floral print summer dress',
      imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
      category: 'Dresses',
      color: 'Pink',
      gender: 'Women',
      price: 89.99,
      brand: 'FloralFashion',
      sizes: ['XS', 'S', 'M', 'L'],
    ),
    const ClothingItemModel(
      id: '7',
      name: 'Little Black Dress',
      description: 'Timeless black dress for any occasion',
      imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=400',
      category: 'Dresses',
      color: 'Black',
      gender: 'Women',
      price: 99.99,
      brand: 'ElegantStyle',
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
    ),
    
    // Jackets
    const ClothingItemModel(
      id: '8',
      name: 'Leather Jacket',
      description: 'Classic black leather jacket with modern cut',
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
      category: 'Jackets',
      color: 'Black',
      gender: 'Unisex',
      price: 199.99,
      brand: 'LeatherPro',
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    const ClothingItemModel(
      id: '9',
      name: 'Denim Jacket',
      description: 'Vintage-style denim jacket with distressed finish',
      imageUrl: 'https://images.unsplash.com/photo-1576871337622-98d48d1cf531?w=400',
      category: 'Jackets',
      color: 'Blue',
      gender: 'Unisex',
      price: 89.99,
      brand: 'DenimWorks',
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    ),
    
    // More items
    const ClothingItemModel(
      id: '10',
      name: 'White Sneakers',
      description: 'Minimalist white sneakers for everyday wear',
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      category: 'Shoes',
      color: 'White',
      gender: 'Unisex',
      price: 79.99,
      brand: 'SneakerLab',
      sizes: ['7', '8', '9', '10', '11', '12'],
    ),
    const ClothingItemModel(
      id: '11',
      name: 'Red Hoodie',
      description: 'Cozy red hoodie with fleece lining',
      imageUrl: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400',
      category: 'Shirts',
      color: 'Red',
      gender: 'Unisex',
      price: 59.99,
      brand: 'ComfyWear',
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    const ClothingItemModel(
      id: '12',
      name: 'Green Cargo Pants',
      description: 'Utility cargo pants with multiple pockets',
      imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400',
      category: 'Pants',
      color: 'Green',
      gender: 'Men',
      price: 74.99,
      brand: 'UrbanStyle',
      sizes: ['28', '30', '32', '34', '36'],
    ),
  ];
}
