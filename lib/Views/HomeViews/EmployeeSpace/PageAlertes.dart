import 'package:flutter/material.dart';
import '../../../navigation/CustomBottomNavigationBar.dart';

class PageAlertes extends StatefulWidget {
  const PageAlertes({super.key});

  @override
  State<PageAlertes> createState() => _PageAlertesState();
}

class _PageAlertesState extends State<PageAlertes> {
  // State variables
  int _currentIndex = 3;
  String _sortBy = 'date';
  final List<Map<String, dynamic>> _alerts = [
    {
      'title': 'Fuite de gaz détectée',
      'date': '24/07/2025 08:15',
      'location': 'Zone A',
      'priority': 'Critique',
      'description': 'Fuite détectée dans le secteur nord.',
      'isRead': false,
    },
    {
      'title': 'Panne électrique',
      'date': '23/07/2025 14:30',
      'location': 'Zone B',
      'priority': 'Modérée',
      'description': 'Panne dans le circuit principal.',
      'isRead': true,
    },
    {
      'title': 'Équipement non conforme',
      'date': '23/07/2025 09:00',
      'location': 'Zone C',
      'priority': 'Mineure',
      'description': 'Vérification requise pour le matériel.',
      'isRead': false,
    },
    {
      'title': 'Incident de sécurité',
      'date': '22/07/2025 16:45',
      'location': 'Point de rassemblement',
      'priority': 'Critique',
      'description': 'Intrusion non autorisée détectée.',
      'isRead': false,
    },
  ];

  void _sortAlerts(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      if (sortBy == 'date') {
        _alerts.sort((a, b) => b['date'].compareTo(a['date']));
      } else {
        const priorityOrder = {'Critique': 1, 'Modérée': 2, 'Mineure': 3};
        _alerts.sort((a, b) => priorityOrder[a['priority']]!.compareTo(priorityOrder[b['priority']]!));
      }
    });
  }

  void _showAddAlertDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String priority = 'Mineure';
    String location = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.add_alert, color: const Color(0xFF005B96)),
                  const SizedBox(width: 8),
                  Text('Ajouter une alerte'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Titre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: priority,
                      decoration: InputDecoration(
                        labelText: 'Priorité',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: ['Critique', 'Modérée', 'Mineure']
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => priority = value!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) => location = value,
                      decoration: InputDecoration(
                        labelText: 'Lieu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                      _addNewAlert(
                        title: titleController.text,
                        description: descriptionController.text,
                        priority: priority,
                        location: location,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005B96),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addNewAlert({
    required String title,
    required String description,
    required String priority,
    required String location,
  }) {
    setState(() {
      _alerts.insert(0, {
        'title': title,
        'date': '24/07/2025 12:21', // Using current date and time
        'location': location,
        'priority': priority,
        'description': description,
        'isRead': false,
      });
    });
    _notifyAllUsers(title, priority);
  }

  void _notifyAllUsers(String title, String priority) {
    // Simulate sending notifications to all users
    // In a real app, this would involve a backend service (e.g., Firebase Cloud Messaging)
    print('Notification sent to all users: New alert "$title" with priority $priority');
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _alerts.where((alert) => !alert['isRead']).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(unreadCount),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  AppBar _buildAppBar(int unreadCount) {
    return AppBar(
      backgroundColor: const Color(0xFF005B96),
      elevation: 0,
      title: Row(
        children: [
          const Text(
            "Mes Alertes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort, color: Colors.white, size: 24),
          onSelected: _sortAlerts,
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'date', child: Text('Trier par date')),
            const PopupMenuItem(value: 'priority', child: Text('Trier par priorité')),
          ],
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
                _buildAlertsSection(),
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

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardHeader(Icons.warning, "Alertes"),
        const SizedBox(height: 16),
        _alerts.isEmpty
            ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF7ED957)),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _alerts.length,
          itemBuilder: (context, index) => _buildAlertCard(_alerts[index]),
        ),
      ],
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            alert['priority'] == 'Critique' ? Colors.red.shade50 : Colors.white,
            alert['priority'] == 'Critique' ? Colors.red.shade100.withOpacity(0.3) : const Color(0xFFF8F9FA),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: alert['priority'] == 'Critique' ? Colors.red.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: alert['priority'] == 'Critique' ? Colors.red.withOpacity(0.1) : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: alert['priority'] == 'Critique'
                        ? Colors.red.withOpacity(0.1)
                        : alert['priority'] == 'Modérée'
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.yellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    alert['priority'] == 'Critique'
                        ? Icons.warning
                        : alert['priority'] == 'Modérée'
                        ? Icons.error_outline
                        : Icons.info_outline,
                    color: alert['priority'] == 'Critique'
                        ? Colors.red
                        : alert['priority'] == 'Modérée'
                        ? Colors.orange
                        : Colors.yellow,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    alert['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF005B96),
                      decoration: alert['isRead'] ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    alert['isRead'] ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF005B96),
                    size: 20,
                  ),
                  onPressed: () => setState(() => alert['isRead'] = !alert['isRead']),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.access_time, "Date", alert['date']),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.place, "Lieu", alert['location']),
            const SizedBox(height: 12),
            Text(
              alert['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: alert['priority'] == 'Critique'
                    ? Colors.red.withOpacity(0.1)
                    : alert['priority'] == 'Modérée'
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.yellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                alert['priority'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: alert['priority'] == 'Critique'
                      ? Colors.red
                      : alert['priority'] == 'Modérée'
                      ? Colors.orange
                      : Colors.yellow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: _fabDecoration(),
      child: FloatingActionButton(
        onPressed: _showAddAlertDialog,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_alert, color: Colors.white, size: 24),
      ),
    );
  }

  BoxDecoration _fabDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF005B96), Color(0xFF007BB8)],
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF005B96).withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
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
          child: Icon(icon, color: const Color(0xFF005B96), size: 24),
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