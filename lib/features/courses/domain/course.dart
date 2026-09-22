enum CourseStatus { notStarted, inProgress, completed }

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.category,
    required this.totalLessons,
    required this.completedLessons,
    required this.status,
    required this.lastAccessedAt,
  });

  final String id;
  final String title;
  final String description;
  final String instructor;
  final String category;
  final int totalLessons;
  final int completedLessons;
  final CourseStatus status;
  final DateTime lastAccessedAt;

  /// 0.0 → 1.0
  double get progress =>
      totalLessons == 0 ? 0 : (completedLessons / totalLessons).clamp(0.0, 1.0);

  int get progressPercent => (progress * 100).round();

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? category,
    int? totalLessons,
    int? completedLessons,
    CourseStatus? status,
    DateTime? lastAccessedAt,
  }) =>
      Course(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        instructor: instructor ?? this.instructor,
        category: category ?? this.category,
        totalLessons: totalLessons ?? this.totalLessons,
        completedLessons: completedLessons ?? this.completedLessons,
        status: status ?? this.status,
        lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      );
}