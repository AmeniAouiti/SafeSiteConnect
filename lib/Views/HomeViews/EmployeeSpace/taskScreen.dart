import 'package:flutter/material.dart';
import '../../../navigation/CustomBottomNavigationBar.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // State variables
  int _currentIndex = 2;
  final List<Map<String, dynamic>> _tasksToday = [
    {
      'title': 'Inspection machine',
      'time': '14:00',
      'location': 'Zone A',
      'status': 'En cours',
      'completed': false,
      'icon': Icons.search,
      'color': Color(0xFF4CAF50),
    },
    {
      'title': 'Rapport sécurité',
      'time': '16:00',
      'location': 'Zone B',
      'status': 'En attente',
      'completed': false,
      'icon': Icons.security,
      'color': Color(0xFFFF9800),
    },
    {
      'title': 'Maintenance préventive',
      'time': '17:00',
      'location': 'Zone C',
      'status': 'En attente',
      'completed': false,
      'icon': Icons.build,
      'color': Color(0xFF2196F3),
    },
  ];

  final List<Map<String, dynamic>> _futureTasks = [
    {
      'title': 'Vérification équipements',
      'date': '23/07/2025',
      'status': 'En attente',
    },
    {
      'title': 'Audit sécurité',
      'date': '24/07/2025',
      'status': 'En attente',
    },
    {
      'title': 'Formation équipe',
      'date': '25/07/2025',
      'status': 'En attente',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF005B96),
      elevation: 0,
      title: const Text(
        "Mes Tâches",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_note, color: Colors.white, size: 24),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderGradient(),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTodayTasksSection(),
                const SizedBox(height: 32),
                _buildFutureTasksSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderGradient() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF005B96), Color(0xFFF8F9FA)],
        ),
      ),
    );
  }

  Widget _buildTodayTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCardHeader(Icons.priority_high, "Tâches du jour"),
            Text(
              "22 juillet 2025",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _tasksToday.isEmpty
            ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF7ED957)),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tasksToday.length,
          itemBuilder: (context, index) => _buildTaskCard(_tasksToday[index]),
        ),
      ],
    );
  }

  Widget _buildFutureTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardHeader(Icons.calendar_month, "À venir"),
        const SizedBox(height: 16),
        _futureTasks.isEmpty
            ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF7ED957)),
        )
            : SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _futureTasks.length,
            itemBuilder: (context, index) => _buildFutureTaskCard(_futureTasks[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task['completed'],
              onChanged: (value) {
                setState(() {
                  task['completed'] = value!;
                  task['status'] = value ? 'Terminée' : 'En attente';
                });
              },
              activeColor: const Color(0xFF7ED957),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: task['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          task['icon'],
                          color: task['color'],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF005B96),
                            decoration: task['completed']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.access_time, "Heure", task['time']),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.place, "Lieu", task['location']),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: task['color'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        task['status'] == 'En cours' ? 'Continuer' : 'Démarrer',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              task['status'] == 'En cours'
                  ? Icons.pending
                  : task['status'] == 'Terminée'
                  ? Icons.check_circle_outline
                  : Icons.schedule,
              color: task['status'] == 'En cours'
                  ? Colors.orange
                  : task['status'] == 'Terminée'
                  ? const Color(0xFF7ED957)
                  : Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureTaskCard(Map<String, dynamic> task) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF005B96).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.task,
                color: Color(0xFF005B96),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    task['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF005B96),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task['date'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              task['status'] == 'En attente' ? Icons.schedule : Icons.check_circle_outline,
              color: task['status'] == 'En attente' ? Colors.grey : const Color(0xFF7ED957),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Color(0xFFF8F9FA)],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildCardHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF005B96).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF005B96), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF005B96),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF005B96),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}