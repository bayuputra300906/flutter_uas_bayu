class TravelNote {
  const TravelNote({
    this.id,
    required this.destinationId,
    required this.destinationName,
    required this.note,
    this.rating = 5.0,
    required this.visitDate,
    this.isVisited = false,
    this.createdAt,
  });

  final int? id;
  final int destinationId;
  final String destinationName;
  final String note;
  final double rating;
  final String visitDate;
  final bool isVisited;
  final String? createdAt;

  factory TravelNote.fromJson(Map<String, dynamic> json) {
    return TravelNote(
      id: json['id'] as int?,
      destinationId: json['destination_id'] as int? ?? json['destinationId'] as int? ?? 0,
      destinationName: json['destination_name'] as String? ?? json['destinationName'] as String? ?? '',
      note: json['note'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      visitDate: json['visit_date'] as String? ?? json['visitDate'] as String? ?? '',
      isVisited: json['is_visited'] as bool? ?? json['isVisited'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'destination_id': destinationId,
        'destination_name': destinationName,
        'note': note,
        'rating': rating,
        'visit_date': visitDate,
        'is_visited': isVisited,
      };

  TravelNote copyWith({
    int? id,
    int? destinationId,
    String? destinationName,
    String? note,
    double? rating,
    String? visitDate,
    bool? isVisited,
    String? createdAt,
  }) {
    return TravelNote(
      id: id ?? this.id,
      destinationId: destinationId ?? this.destinationId,
      destinationName: destinationName ?? this.destinationName,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      visitDate: visitDate ?? this.visitDate,
      isVisited: isVisited ?? this.isVisited,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
