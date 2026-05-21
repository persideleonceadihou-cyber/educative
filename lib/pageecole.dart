import 'package:flutter/material.dart';

import 'liste_eleves_page.dart';
import 'school_models.dart';

class Pageecole extends StatefulWidget {
  const Pageecole({super.key});

  @override
  State<Pageecole> createState() => _PageecoleState();
}

class _PageecoleState extends State<Pageecole> {
  int _selectedIndex = 0;

  List<String> _schoolClasses = const ['6eme', '5eme', '4eme'];

  List<SchoolStudent> _students = const [
    SchoolStudent(
      name: 'Thomas Dupont',
      schoolClass: '6eme',
      isPresent: true,
      grades: [
        SchoolGrade(subject: 'Mathematiques', value: 16),
        SchoolGrade(subject: 'Francais', value: 14),
        SchoolGrade(subject: 'Sciences', value: 15),
      ],
    ),
    SchoolStudent(
      name: 'Emma Leroy',
      schoolClass: '5eme',
      isPresent: true,
      grades: [
        SchoolGrade(subject: 'Mathematiques', value: 18),
        SchoolGrade(subject: 'Sciences', value: 17),
        SchoolGrade(subject: 'Histoire', value: 16),
      ],
    ),
    SchoolStudent(
      name: 'Lea Martin',
      schoolClass: '4eme',
      isPresent: false,
      grades: [
        SchoolGrade(subject: 'Francais', value: 13),
        SchoolGrade(subject: 'Anglais', value: 12),
        SchoolGrade(subject: 'Sciences', value: 14),
      ],
    ),
    SchoolStudent(
      name: 'Noah Bernard',
      schoolClass: '6eme',
      isPresent: true,
      grades: [
        SchoolGrade(subject: 'Mathematiques', value: 12),
        SchoolGrade(subject: 'Histoire', value: 15),
      ],
    ),
  ];

  int get _presentCount =>
      _students.where((student) => student.isPresent).length;

  int get _absenceCount => _students.length - _presentCount;

  List<String> get _classes {
    final classes = <String>{..._schoolClasses};
    for (final student in _students) {
      classes.add(student.schoolClass);
    }
    return classes.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tableau de bord de l'ecole",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              'Suivi des eleves',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF5B5FC7),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _changePage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Eleves'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Notes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'Presences',
          ),
        ],
      ),
    );
  }

  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addGrade(int studentIndex, SchoolGrade grade) {
    final student = _students[studentIndex];
    final updatedGrades = [...student.grades, grade];
    final updatedStudents = [..._students];
    updatedStudents[studentIndex] = student.copyWith(grades: updatedGrades);

    setState(() {
      _students = updatedStudents;
    });
  }

  void _addStudent(SchoolStudent student) {
    setState(() {
      _students = [..._students, student];
      if (!_schoolClasses.contains(student.schoolClass)) {
        _schoolClasses = [..._schoolClasses, student.schoolClass]..sort();
      }
    });
  }

  void _addClass(String schoolClass) {
    final normalizedClass = schoolClass.trim();
    if (normalizedClass.isEmpty || _classes.contains(normalizedClass)) {
      return;
    }

    setState(() {
      _schoolClasses = [..._schoolClasses, normalizedClass]..sort();
    });
  }

  Widget _buildBody() {
    if (_selectedIndex == 1) {
      return ListeElevesPage(
        students: _students,
        classes: _classes,
        onAddStudent: _addStudent,
        onAddClass: _addClass,
      );
    }
    if (_selectedIndex == 2) {
      return NotesEcolePage(students: _students, onAddGrade: _addGrade);
    }
    if (_selectedIndex == 3) {
      return PresencesPage(students: _students);
    }
    return AccueilEcolePage(
      students: _students,
      classes: _classes,
      absenceCount: _absenceCount,
      onOpenPage: _openPage,
    );
  }
}

class AccueilEcolePage extends StatelessWidget {
  const AccueilEcolePage({
    super.key,
    required this.students,
    required this.classes,
    required this.absenceCount,
    required this.onOpenPage,
  });

  final List<SchoolStudent> students;
  final List<String> classes;
  final int absenceCount;
  final ValueChanged<int> onOpenPage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              StartCard(
                title: 'Eleves',
                value: '${students.length}',
                color: Colors.blue,
                icon: Icons.people,
                onTap: () => onOpenPage(1),
              ),
              const SizedBox(width: 16),
              StartCard(
                title: 'Notes',
                value: 'Ajouter',
                color: Colors.orange,
                icon: Icons.edit,
                onTap: () => onOpenPage(2),
              ),
              const SizedBox(width: 16),
              StartCard(
                title: 'Absences',
                value: '$absenceCount',
                color: Colors.red,
                icon: Icons.event_busy,
                onTap: () => onOpenPage(3),
              ),
              const SizedBox(width: 16),
              StartCard(
                title: 'Classes',
                value: '${classes.length}',
                color: Colors.blue,
                icon: Icons.class_,
                onTap: () => onOpenPage(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Liste des classes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2F63),
          ),
        ),
        const SizedBox(height: 12),
        ..._classCards(),
      ],
    );
  }

  List<Widget> _classCards() {
    final studentCountByClass = <String, int>{};
    for (final schoolClass in classes) {
      studentCountByClass[schoolClass] = 0;
    }
    for (final student in students) {
      studentCountByClass[student.schoolClass] =
          (studentCountByClass[student.schoolClass] ?? 0) + 1;
    }

    if (studentCountByClass.isEmpty) {
      return [
        EcoleInfoCard(
          title: 'Aucune classe',
          subtitle: 'Ajoutez une classe depuis la page Eleves',
          detail: 'Ajouter',
          icon: Icons.class_,
          color: Colors.orangeAccent,
          onTap: () => onOpenPage(1),
        ),
      ];
    }

    return studentCountByClass.entries.map((entry) {
      return EcoleInfoCard(
        title: entry.key,
        subtitle: '${entry.value} eleve${entry.value > 1 ? 's' : ''}',
        detail: 'Voir',
        icon: Icons.class_,
        color: Colors.indigo,
        onTap: () => onOpenPage(1),
      );
    }).toList();
  }
}

class NotesEcolePage extends StatelessWidget {
  const NotesEcolePage({
    super.key,
    required this.students,
    required this.onAddGrade,
  });

  final List<SchoolStudent> students;
  final void Function(int studentIndex, SchoolGrade grade) onAddGrade;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EcoleHeaderCard(
          title: 'Notes',
          subtitle: 'Notes par matiere et moyenne generale',
          color: Colors.blue,
          icon: Icons.edit,
          action: IconButton(
            tooltip: 'Ajouter une note',
            onPressed: students.isEmpty
                ? null
                : () => _showAddGradeDialog(context),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: students.isEmpty
                ? null
                : () => _showAddGradeDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une note'),
          ),
        ),
        const SizedBox(height: 16),
        if (students.isEmpty)
          const EcoleInfoCard(
            title: 'Aucun eleve',
            subtitle: 'Ajoutez d abord un eleve dans la page Eleves',
            detail: 'Vide',
            icon: Icons.info,
            color: Colors.grey,
          ),
        ...students.asMap().entries.map(
              (entry) => StudentGradeCard(
                studentIndex: entry.key,
                student: entry.value,
                onAddGrade: onAddGrade,
              ),
            ),
      ],
    );
  }

  void _showAddGradeDialog(BuildContext context, {int? studentIndex}) {
    if (students.isEmpty) {
      return;
    }

    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController();
    final gradeController = TextEditingController();
    int selectedStudentIndex = studentIndex ?? 0;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Ajouter une note'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedStudentIndex,
                      decoration: const InputDecoration(
                        labelText: 'Eleve',
                        border: OutlineInputBorder(),
                      ),
                      items: students.asMap().entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setDialogState(() {
                          selectedStudentIndex = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Matiere',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Entrez la matiere.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: gradeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Note sur 20',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final grade = double.tryParse(
                          (value ?? '').replaceAll(',', '.'),
                        );
                        if (grade == null) {
                          return 'Entrez une note valide.';
                        }
                        if (grade < 0 || grade > 20) {
                          return 'La note doit etre entre 0 et 20.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    final grade = SchoolGrade(
                      subject: subjectController.text.trim(),
                      value: double.parse(
                        gradeController.text.trim().replaceAll(',', '.'),
                      ),
                    );

                    onAddGrade(selectedStudentIndex, grade);
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      subjectController.dispose();
      gradeController.dispose();
    });
  }
}

class StudentGradeCard extends StatelessWidget {
  const StudentGradeCard({
    super.key,
    required this.studentIndex,
    required this.student,
    required this.onAddGrade,
  });

  final int studentIndex;
  final SchoolStudent student;
  final void Function(int studentIndex, SchoolGrade grade) onAddGrade;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withAlpha(46),
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('Classe ${student.schoolClass}'),
                    ],
                  ),
                ),
                Text(
                  student.average > 0
                      ? 'Moy. ${_formatGrade(student.average)}'
                      : 'Sans note',
                  style: const TextStyle(
                    color: Color(0xFF5B5FC7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (student.grades.isEmpty)
              const Text('Aucune note ajoutee.')
            else
              ...student.grades.map(
                (grade) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(grade.subject)),
                      Text(
                        _formatGrade(grade.value),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showAddGradeDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter une note'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGradeDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController();
    final gradeController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Note de ${student.name}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Matiere',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Entrez la matiere.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: gradeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Note sur 20',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final grade = double.tryParse(
                      (value ?? '').replaceAll(',', '.'),
                    );
                    if (grade == null) {
                      return 'Entrez une note valide.';
                    }
                    if (grade < 0 || grade > 20) {
                      return 'La note doit etre entre 0 et 20.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final grade = SchoolGrade(
                  subject: subjectController.text.trim(),
                  value: double.parse(
                    gradeController.text.trim().replaceAll(',', '.'),
                  ),
                );

                onAddGrade(studentIndex, grade);
                Navigator.pop(dialogContext);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    ).then((_) {
      subjectController.dispose();
      gradeController.dispose();
    });
  }
}

class PresencesPage extends StatelessWidget {
  const PresencesPage({super.key, required this.students});

  final List<SchoolStudent> students;

  @override
  Widget build(BuildContext context) {
    final presentCount = students.where((student) => student.isPresent).length;
    final absenceCount = students.length - presentCount;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EcoleHeaderCard(
          title: 'Presences',
          subtitle: '$presentCount presents, $absenceCount absents',
          color: Colors.lightBlueAccent,
          icon: Icons.event_available,
        ),
        const SizedBox(height: 16),
        ...students.map(
          (student) => EcoleInfoCard(
            title: student.name,
            subtitle: 'Classe ${student.schoolClass}',
            detail: student.isPresent ? 'Present' : 'Absent',
            icon: student.isPresent ? Icons.check_circle : Icons.warning,
            color: student.isPresent ? Colors.lightBlueAccent : Colors.red,
          ),
        ),
      ],
    );
  }
}

class EcoleHeaderCard extends StatelessWidget {
  const EcoleHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.action,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}

class EcoleInfoCard extends StatelessWidget {
  const EcoleInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String detail;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(46),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          detail,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class StartCard extends StatelessWidget {
  const StartCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
    this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Card(
        color: color,
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, color: Colors.white, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatGrade(double grade) {
  final rounded = grade.toStringAsFixed(1);
  final formatted = rounded.endsWith('.0')
      ? rounded.substring(0, rounded.length - 2)
      : rounded;
  return '$formatted/20';
}
