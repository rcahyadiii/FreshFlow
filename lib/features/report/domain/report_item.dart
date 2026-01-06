class ReportItem {
  final DateTime date;
  final String address;
  final List<String> images;
  final List<String> videos;
  final String description;
  final List<String> categories;
  final bool completed;
  final int? rating; // 1..5
  final String? review;
  final List<String> resolveImages;
  final String? resolveDescription;

  const ReportItem({
    required this.date,
    required this.address,
    required this.images,
    required this.videos,
    required this.description,
    required this.categories,
    this.completed = false,
    this.rating,
    this.review,
    this.resolveImages = const [],
    this.resolveDescription,
  });

  ReportItem markCompleted() => ReportItem(
        date: date,
        address: address,
        images: images,
        videos: videos,
        description: description,
        categories: categories,
        completed: true,
        rating: rating,
        review: review,
        resolveImages: resolveImages,
        resolveDescription: resolveDescription,
      );

  ReportItem copyWith({
    DateTime? date,
    String? address,
    List<String>? images,
    List<String>? videos,
    String? description,
    List<String>? categories,
    bool? completed,
    int? rating,
    String? review,
    List<String>? resolveImages,
    String? resolveDescription,
  }) => ReportItem(
        date: date ?? this.date,
        address: address ?? this.address,
        images: images ?? this.images,
        videos: videos ?? this.videos,
        description: description ?? this.description,
        categories: categories ?? this.categories,
        completed: completed ?? this.completed,
        rating: rating ?? this.rating,
        review: review ?? this.review,
        resolveImages: resolveImages ?? this.resolveImages,
        resolveDescription: resolveDescription ?? this.resolveDescription,
      );
}
