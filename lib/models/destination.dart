class Destination {
  const Destination({
    this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.description,
    this.imageUrl = '',
    required this.price,
    required this.rating,
    this.tags = const ['24/7 Access', 'Scenic View', 'Island Friendly'],
  });

  final int? id;
  final String name;
  final String location;
  final String category;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final List<String> tags;

  factory Destination.fromJson(Map<String, dynamic> json) {
    List<String> parsedTags;
    if (json['tags'] is List) {
      parsedTags = (json['tags'] as List).map((e) => e.toString()).toList();
    } else {
      parsedTags = const ['24/7 Access', 'Scenic View', 'Island Friendly'];
    }

    return Destination(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      category: json['category'] as String? ?? 'Wisata Alam',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      tags: parsedTags,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
        'category': category,
        'description': description,
        'image_url': imageUrl,
        'price': price,
        'rating': rating,
      };

  Destination copyWith({
    int? id,
    String? name,
    String? location,
    String? category,
    String? description,
    String? imageUrl,
    double? price,
    double? rating,
    List<String>? tags,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
    );
  }
}
