import 'package:flutter/material.dart';

class StudentData {
  const StudentData({
    required this.name,
    required this.average,
    required this.absences,
    required this.behavior,
    required this.notes,
    required this.homework,
  });

  final String name;
  final String average;
  final String absences;
  final String behavior;
  final List<NoteInfo> notes;
  final List<HomeworkInfo> homework;
}

class NoteInfo {
  const NoteInfo({
    required this.subject,
    required this.note,
    required this.appreciation,
    required this.color,
    required this.icon,
  });

  final String subject;
  final String note;
  final String appreciation;
  final Color color;
  final IconData icon;
}

class HomeworkInfo {
  const HomeworkInfo({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String detail;
  final Color color;
  final IconData icon;
}

class Parentdashboard extends StatefulWidget {
  const Parentdashboard({super.key, this.userName = 'Utilisateur'});

  final String userName;

  @override
  State<Parentdashboard> createState() => _ParentdashboardState();
}

class _ParentdashboardState extends State<Parentdashboard> {
  int _selectedIndex = 0;
  int _selectedStudentIndex = 0;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  final List<StudentData> students = const [
    StudentData(
      name: 'Lucas',
      average: '15/20',
      absences: '2',
      behavior: 'Bon',
      notes: [
        NoteInfo(
          subject: 'Mathematiques',
          note: '16/20',
          appreciation: 'Tres bien',
          color: Colors.blue,
          icon: Icons.calculate,
        ),
        NoteInfo(
          subject: 'Francais',
          note: '14/20',
          appreciation: 'Bon niveau',
          color: Colors.orange,
          icon: Icons.menu_book,
        ),
      ],
      homework: [
        HomeworkInfo(
          title: 'Sciences',
          subtitle: 'Recherche sur les plantes',
          detail: 'Pour vendredi',
          color: Colors.blueAccent,
          icon: Icons.science,
        ),
      ],
    ),
    StudentData(
      name: 'Emma',
      average: '17/20',
      absences: '0',
      behavior: 'Tres bon',
      notes: [
        NoteInfo(
          subject: 'Mathematiques',
          note: '18/20',
          appreciation: 'Excellent',
          color: Colors.orangeAccent,
          icon: Icons.calculate,
        ),
        NoteInfo(
          subject: 'Sciences',
          note: '16/20',
          appreciation: 'Bon travail',
          color: Colors.pinkAccent,
          icon: Icons.science,
        ),
      ],
      homework: [
        HomeworkInfo(
          title: 'Francais',
          subtitle: 'Lire le chapitre 4',
          detail: 'Pour mardi',
          color: Colors.orange,
          icon: Icons.menu_book,
        ),
      ],
    ),
    StudentData(
      name: 'Noah',
      average: '13/20',
      absences: '1',
      behavior: 'A suivre',
      notes: [
        NoteInfo(
          subject: 'Histoire',
          note: '13/20',
          appreciation: 'Peut mieux faire',
          color: Colors.blue,
          icon: Icons.history_edu,
        ),
        NoteInfo(
          subject: 'Francais',
          note: '12/20',
          appreciation: 'A ameliorer',
          color: Colors.orange,
          icon: Icons.menu_book,
        ),
      ],
      homework: [
        HomeworkInfo(
          title: 'Mathematiques',
          subtitle: 'Exercices page 32',
          detail: 'Pour lundi',
          color: Colors.blue,
          icon: Icons.calculate,
        ),
      ],
    ),
  ];

  StudentData get selectedStudent => students[_selectedStudentIndex];

  List<StudentData> get filteredStudents {
    if (_searchText.trim().isEmpty) {
      return const [];
    }

    return students
        .where(
          (student) => student.name.toLowerCase().contains(
                _searchText.trim().toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor:Colors.blueAccent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bonjour, ${widget.userName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rechercher un enfant...')),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF5B5FC7),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Devoirs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendrier',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 1) {
      return const DevoirsContent();
    }
    if (_selectedIndex == 2) {
      return const MessagesContent();
    }
    if (_selectedIndex == 3) {
      return const CalendrierContent();
    }
    return _buildAccueil();
  }

  Widget _buildAccueil() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
        
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Recherche enfant',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchText = '';
                          });
                        },
                      ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            if (filteredStudents.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: filteredStudents.map((student) {
                  return ActionChip(
                    label: Text(student.name),
                    onPressed: () {
                      setState(() {
                        _selectedStudentIndex = students.indexOf(student);
                        _searchController.text = student.name;
                        _searchText = '';
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotesPage()),
          );
        },
        child: StartCard(
          title: 'Notes',
          value: selectedStudent.average,
          color: Colors.lightBlueAccent,
          icon: Icons.school,
        ),

      ),
      const SizedBox(width: 16),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const DevoirsPage()));
        },
        child: StartCard(
          title: 'Devoirs',
          value: '${selectedStudent.homework.length} en cours',
          color: Colors.orangeAccent,
          icon: Icons.assignment,
        ),
      ),
      const SizedBox(width: 16),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AbsencesPage()));
        },
        child: StartCard(
          title: 'Absences',
          value: selectedStudent.absences,
          color: Colors.redAccent,
          icon: Icons.event_busy,
        ),
      ),
      const SizedBox(width: 16),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ComportementPage()));
        },
        child: StartCard(
          title: 'Comportement',
          value: selectedStudent.behavior,
          color: Colors.pink,
          icon: Icons.emoji_people,
        ),
      ),
                ],
              ),
            ),
const SizedBox(height: 24),

        PageHeaderCard(
          title: "Suivi ${selectedStudent.name}",
          subtitle: "Dernieres informations scolaires",
          color: Colors.blueAccent,
          icon: Icons.person,
        ),
        const SizedBox(height: 16),

        ...selectedStudent.notes.map(
          (note) => NoteCard(
            matiere: note.subject,
            note: note.note,
            appreciation: note.appreciation,
            color: note.color,
            icon: note.icon,
          ),
        ),
        const SizedBox(height: 20),

        PageHeaderCard(
          title: "Devoirs en cours",
          subtitle: "A rendre cette semaine",
          color: Colors.orange,
          icon: Icons.assignment,
        ),
        ...selectedStudent.homework.map(
          (homework) => SimpleInfoCard(
            title: homework.title,
            subtitle: homework.subtitle,
            detail: homework.detail,
            icon: homework.icon,
            color: homework.color,
          ),
        ),

          ],  
            
        ),
      );
  }
}

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Notes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Card(
            color: Colors.pinkAccent,
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Moyenne générale',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '15/20',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFCE4EC),),
                    ),
                  SizedBox(height: 12),
                  SizedBox(height: 6),
                  Text(
                    'Très bon travail, continue comme ça.',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Détails par matière',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2F63),
            ),
          ),
          SizedBox(height: 12),
          NoteCard(
            matiere: 'Mathématiques',
            note: '16/20',
            appreciation: 'Très bien',
            color: Colors.blue,
            icon: Icons.calculate,
          ),
          NoteCard(
            matiere: 'Français',
            note: '14/20',
            appreciation: 'Bon niveau',
            color: Colors.orange,
            icon: Icons.menu_book,
          ),
          NoteCard(
            matiere: 'Sciences',
            note: '15/20',
            appreciation: 'Bon travail',
            color: Colors.green,
            icon: Icons.science,
          ),
          NoteCard(
            matiere: 'Histoire',
            note: '13/20',
            appreciation: 'Peut mieux faire',
            color: Colors.purple,
            icon: Icons.history_edu,
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.matiere,
    required this.note,
    required this.appreciation,
    required this.color,
    required this.icon,
  });

  final String matiere;
  final String note;
  final String appreciation;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(46),
          child: Icon(icon, color: color),
        ),
        title: Text(
          matiere,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(appreciation),
        trailing: Text(
          note,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DevoirsPage extends StatelessWidget {
  const DevoirsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B5FC7),
        title: const Text('Devoirs'),
      ),
      body: const DevoirsContent(),
    );
  }
}

class DevoirsContent extends StatelessWidget {
  const DevoirsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        PageHeaderCard(
          title: '3 devoirs en cours',
          subtitle: 'Les devoirs a faire cette semaine',
          color: Colors.orange,
          icon: Icons.assignment,
        ),
        SizedBox(height: 16),
        SimpleInfoCard(
          title: 'Mathematiques',
          subtitle: 'Exercices page 24, numeros 1 a 5',
          detail: 'Pour lundi',
          icon: Icons.calculate,
          color: Colors.blue,
        ),
        SimpleInfoCard(
          title: 'Francais',
          subtitle: 'Lire le chapitre 3 et faire le resume',
          detail: 'Pour mercredi',
          icon: Icons.menu_book,
          color: Colors.orange,
        ),
        SimpleInfoCard(
          title: 'Sciences',
          subtitle: 'Preparer une recherche sur les plantes',
          detail: 'Pour vendredi',
          icon: Icons.science,
          color: Colors.green,
        ),
      ],
    );
  }
}

class MessagesContent extends StatelessWidget {
  const MessagesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        PageHeaderCard(
          title: 'Messages',
          subtitle: 'Vos derniers messages avec l ecole',
          color: Colors.blue,
          icon: Icons.message,
        ),
        SizedBox(height: 16),
        SimpleInfoCard(
          title: 'Professeur de maths',
          subtitle: 'Votre enfant progresse bien cette semaine.',
          detail: 'Aujourd hui',
          icon: Icons.person,
          color: Colors.blue,
        ),
        SimpleInfoCard(
          title: 'Administration',
          subtitle: 'Rappel de la reunion des parents.',
          detail: 'Hier',
          icon: Icons.school,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class CalendrierContent extends StatelessWidget {
  const CalendrierContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        PageHeaderCard(
          title: 'Calendrier',
          subtitle: 'Evenements importants a venir',
          color: Colors.orange,
          icon: Icons.calendar_month,
        ),
        SizedBox(height: 16),
        SimpleInfoCard(
          title: 'Reunion parents',
          subtitle: 'Rencontre avec les enseignants',
          detail: '20 mai',
          icon: Icons.groups,
          color: Colors.blueAccent,
        ),
        SimpleInfoCard(
          title: 'Controle de sciences',
          subtitle: 'Revision conseillee cette semaine',
          detail: '24 mai',
          icon: Icons.science,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class AbsencesPage extends StatelessWidget {
  const AbsencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B5FC7),
        title: const Text('Absences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          PageHeaderCard(
            title: '2 absences',
            subtitle: 'Suivi des absences de votre enfant',
            color: Colors.red,
            icon: Icons.event_busy,
          ),
          SizedBox(height: 16),
          SimpleInfoCard(
            title: 'Lundi 6 mai',
            subtitle: 'Absence le matin',
            detail: 'Justifiee',
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          SimpleInfoCard(
            title: 'Jeudi 9 mai',
            subtitle: 'Absence en cours de sport',
            detail: 'A justifier',
            icon: Icons.warning,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class ComportementPage extends StatelessWidget {
  const ComportementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B5FC7),
        title: const Text('Comportement'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          PageHeaderCard(
            title: 'Comportement : Bon',
            subtitle: 'Evaluation generale en classe',
            color: Colors.green,
            icon: Icons.emoji_people,
          ),
          SizedBox(height: 16),
          SimpleInfoCard(
            title: 'Participation',
            subtitle: 'Participe souvent pendant les cours',
            detail: 'Tres bien',
            icon: Icons.record_voice_over,
            color: Colors.green,
          ),
          SimpleInfoCard(
            title: 'Discipline',
            subtitle: 'Respecte les consignes de la classe',
            detail: 'Bon',
            icon: Icons.verified,
            color: Colors.blue,
          ),
          SimpleInfoCard(
            title: 'Remarque',
            subtitle: 'Doit continuer a rester concentre',
            detail: 'A suivre',
            icon: Icons.info,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class PageHeaderCard extends StatelessWidget {
  const PageHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

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
          ],
        ),
      ),
    );
  }
}

class SimpleInfoCard extends StatelessWidget {
  const SimpleInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
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
    this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120, // largeur fixe pour garder l’alignement
      child: Card(
        color: color,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.blue, size: 28),
              const SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
