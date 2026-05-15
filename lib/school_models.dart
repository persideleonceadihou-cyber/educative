class SchoolGrade {
  const SchoolGrade({
    required this.subject,
    required this.value,
  });

  final String subject;
  final double value;
}

class SchoolStudent {
  const SchoolStudent({
    required this.name,
    required this.schoolClass,
    required this.isPresent,
    required this.grades,
  });

  final String name;
  final String schoolClass;
  final bool isPresent;
  final List<SchoolGrade> grades;

  double get average {
    if (grades.isEmpty) {
      return 0;
    }

    final total = grades.fold<double>(0, (sum, grade) => sum + grade.value);
    return total / grades.length;
  }

  SchoolStudent copyWith({
    String? name,
    String? schoolClass,
    bool? isPresent,
    List<SchoolGrade>? grades,
  }) {
    return SchoolStudent(
      name: name ?? this.name,
      schoolClass: schoolClass ?? this.schoolClass,
      isPresent: isPresent ?? this.isPresent,
      grades: grades ?? this.grades,
    );
  }
}
