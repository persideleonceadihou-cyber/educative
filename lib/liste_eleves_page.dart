import 'package:flutter/material.dart';

import 'school_models.dart';

class ListeElevesPage extends StatefulWidget {
  const ListeElevesPage({
    super.key,
    required this.students,
    required this.onAddStudent,
  });

  final List<SchoolStudent> students;
  final ValueChanged<SchoolStudent> onAddStudent;

  @override
  State<ListeElevesPage> createState() => _ListeElevesPageState();
}

class _ListeElevesPageState extends State<ListeElevesPage> {
  String? _selectedClass;

  Map<String, List<SchoolStudent>> get _studentsByClass {
    final classes = <String, List<SchoolStudent>>{};
    for (final student in widget.students) {
      classes.putIfAbsent(student.schoolClass, () => []).add(student);
    }
    return classes;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedClass != null) {
      return _buildClassStudents(_selectedClass!);
    }

    final classes = _studentsByClass.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _HeaderCard(
          title: 'Liste des classes',
          subtitle: '${classes.length} classes disponibles',
          color: Colors.indigo,
          icon: Icons.class_,
          action: IconButton(
            tooltip: 'Ajouter un eleve',
            onPressed: () => _showAddStudentDialog(context),
            icon: const Icon(Icons.person_add, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showAddStudentDialog(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Ajouter un eleve'),
          ),
        ),
        const SizedBox(height: 16),
        ...classes.map(
          (entry) => _InfoCard(
            title: 'Classe ${entry.key}',
            subtitle:
                '${entry.value.length} eleve${entry.value.length > 1 ? 's' : ''}',
            detail: 'Ouvrir',
            icon: Icons.class_,
            color: Colors.indigo,
            onTap: () {
              setState(() {
                _selectedClass = entry.key;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClassStudents(String schoolClass) {
    final classStudents = _studentsByClass[schoolClass] ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _HeaderCard(
          title: 'Classe $schoolClass',
          subtitle:
              '${classStudents.length} eleve${classStudents.length > 1 ? 's' : ''}',
          color: Colors.indigo,
          icon: Icons.people,
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Ajouter un eleve',
                onPressed: () => _showAddStudentDialog(
                  context,
                  initialClass: schoolClass,
                ),
                icon: const Icon(Icons.person_add, color: Colors.white),
              ),
              IconButton(
                tooltip: 'Retour aux classes',
                onPressed: () {
                  setState(() {
                    _selectedClass = null;
                  });
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showAddStudentDialog(
              context,
              initialClass: schoolClass,
            ),
            icon: const Icon(Icons.person_add),
            label: const Text('Ajouter un eleve dans cette classe'),
          ),
        ),
        const SizedBox(height: 16),
        ...classStudents.map(
          (student) => _InfoCard(
            title: student.name,
            subtitle: 'Classe ${student.schoolClass}',
            detail: student.average > 0
                ? 'Moy. ${_formatGrade(student.average)}'
                : 'Sans note',
            icon: Icons.person,
            color: student.isPresent ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  void _showAddStudentDialog(BuildContext context, {String? initialClass}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final classController = TextEditingController(text: initialClass ?? '');
    bool isPresent = true;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Ajouter un eleve'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom de l eleve',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Entrez le nom de l eleve.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: classController,
                      decoration: const InputDecoration(
                        labelText: 'Classe',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Entrez la classe.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Present aujourd hui'),
                      value: isPresent,
                      onChanged: (value) {
                        setDialogState(() {
                          isPresent = value;
                        });
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

                    final student = SchoolStudent(
                      name: nameController.text.trim(),
                      schoolClass: classController.text.trim(),
                      isPresent: isPresent,
                      grades: const [],
                    );

                    widget.onAddStudent(student);
                    setState(() {
                      _selectedClass = student.schoolClass;
                    });
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
      nameController.dispose();
      classController.dispose();
    });
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
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
        padding: const EdgeInsets.all(18),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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

String _formatGrade(double grade) {
  final rounded = grade.toStringAsFixed(1);
  final formatted = rounded.endsWith('.0')
      ? rounded.substring(0, rounded.length - 2)
      : rounded;
  return '$formatted/20';
}
