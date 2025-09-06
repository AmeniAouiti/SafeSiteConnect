import 'package:flutter/material.dart';
import 'CustomBottomNavigationBarAdmin.dart';

class TacheEmployScreen extends StatefulWidget {
  const TacheEmployScreen({super.key});

  @override
  State<TacheEmployScreen> createState() => _TacheEmployScreenState();
}

class _TacheEmployScreenState extends State<TacheEmployScreen> with TickerProviderStateMixin {
  int _currentIndex = 3; // Assuming tasks is the 4th tab
  final String _adminName = "Admin Principal";
  String _searchQuery = '';
  String _sortBy = 'date';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _tasks = [
    {
      'id': 'TASK001',
      'title': 'Maintenance serveur',
      'date': '2025-09-05 09:00',
      'zone': 'Data Center A',
      'type': 'Maintenance',
      'priority': 'P1',
      'status': 'New',
      'assignedTo': 'Hassan Fayech',
      'description': 'Effectuer la maintenance du serveur principal.',
      'isCompleted': false,
      'auditLog': [
        {'timestamp': '2025-09-05 09:05', 'action': 'Tâche créée', 'user': 'Système'},
      ],
    },
    {
      'id': 'TASK002',
      'title': 'Inspection qualité',
      'date': '2025-09-04 14:00',
      'zone': 'Zone C',
      'type': 'Qualité',
      'priority': 'P2',
      'status': 'In Progress',
      'assignedTo': 'Sara Mansouri',
      'description': 'Vérifier la conformité des équipements.',
      'isCompleted': false,
      'auditLog': [
        {'timestamp': '2025-09-04 14:05', 'action': 'Tâche créée', 'user': 'Système'},
        {'timestamp': '2025-09-04 14:10', 'action': 'Assignée à Sara Mansouri', 'user': 'Admin'},
      ],
    },
  ];

  Map<String, String?> _filters = {
    'zone': null,
    'type': null,
    'priority': null,
    'status': null,
  };

  final Map<String, int> _priorityOrder = {
    'P1': 1,
    'P2': 2,
    'P3': 3,
  };

  List<Map<String, dynamic>> get filteredTasks {
    var result = _tasks.where((task) {
      final matchesSearch = _searchQuery.isEmpty ||
          task['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilters = (_filters['zone'] == null || task['zone'] == _filters['zone']) &&
          (_filters['type'] == null || task['type'] == _filters['type']) &&
          (_filters['priority'] == null || task['priority'] == _filters['priority']) &&
          (_filters['status'] == null || task['status'] == _filters['status']);
      return matchesSearch && matchesFilters;
    }).toList();

    if (_sortBy == 'date') {
      result.sort((a, b) => b['date'].compareTo(a['date']));
    } else {
      result.sort((a, b) => _priorityOrder[a['priority']]!.compareTo(_priorityOrder[b['priority']]!));
    }
    return result;
  }

  void _sortItems(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _tasks.where((task) => !task['isCompleted']).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(pendingCount),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: CustomBottomNavigationBarAdmin(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  AppBar _buildAppBar(int pendingCount) {
    return AppBar(
      backgroundColor: const Color(0xFF005B96),
      elevation: 0,
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Gestion des tâches",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _adminName,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (pendingCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  pendingCount.toString(),
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
          onSelected: _sortItems,
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'date', child: Text('Trier par date')),
            const PopupMenuItem(value: 'priority', child: Text('Trier par priorité')),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white, size: 24),
          onPressed: _showFilterDialog,
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white, size: 24),
          onPressed: _showCalendarDialog,
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
                _buildSearchSection(),
                const SizedBox(height: 16),
                _buildTabsSection(),
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

  Widget _buildSearchSection() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: "Rechercher par titre ou ID...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildTabsSection() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF005B96),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: const [
                Tab(text: "Tâches"),
                Tab(text: "Audit"),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            padding: const EdgeInsets.all(16),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTasksTab(),
                _buildAuditTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return filteredTasks.isEmpty
        ? _buildEmptyState()
        : ListView.separated(
      itemCount: filteredTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildTaskCard(filteredTasks[index]),
    );
  }

  Widget _buildAuditTab() {
    return filteredTasks.isEmpty
        ? _buildEmptyState()
        : ListView.separated(
      itemCount: filteredTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildAuditCard(filteredTasks[index]),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    Color priorityColor = _getPriorityColor(task['priority']);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            task['priority'] == 'P1' ? Colors.red.shade50 : Colors.white,
            task['priority'] == 'P1' ? Colors.red.shade100.withOpacity(0.3) : const Color(0xFFF8F9FA),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: task['priority'] == 'P1' ? Colors.red.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: task['priority'] == 'P1' ? Colors.red.withOpacity(0.1) : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    task['priority'] == 'P1'
                        ? Icons.warning
                        : task['priority'] == 'P2'
                        ? Icons.error_outline
                        : Icons.info_outline,
                    color: priorityColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['id'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005B96),
                        ),
                      ),
                      Text(
                        task['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF005B96),
                          decoration: task['isCompleted'] ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    task['isCompleted'] ? Icons.check_circle : Icons.circle_outlined,
                    color: const Color(0xFF005B96),
                    size: 20,
                  ),
                  onPressed: () => setState(() {
                    final index = _tasks.indexWhere((t) => t['id'] == task['id']);
                    _tasks[index]['isCompleted'] = !task['isCompleted'];
                    _tasks[index]['auditLog'].add({
                      'timestamp': DateTime.now().toString(),
                      'action': task['isCompleted'] ? 'Marquée comme non terminée' : 'Marquée comme terminée',
                      'user': _adminName,
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.access_time, "Date", task['date']),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.place, "Lieu", task['zone']),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.category, "Type", task['type']),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.info, "Statut", task['status']),
            const SizedBox(height: 12),
            Text(
              task['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task['priority'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: priorityColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task['assignedTo'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAssignDialog(task),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005B96),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.person, size: 16),
                    label: const Text("Assigner", style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteTask(task),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text("Supprimer", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditCard(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF005B96).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.history, color: Color(0xFF005B96), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['id'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005B96),
                        ),
                      ),
                      Text(
                        task['title'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: task['auditLog'].map<Widget>((log) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log['timestamp'],
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            Text(
                              '${log['action']} par ${log['user']}',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF005B96)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Text(
            "Aucune tâche trouvée",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          Text(
            "Essayez d'autres filtres ou termes de recherche",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: _fabDecoration(),
      child: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_task, color: Colors.white, size: 24),
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'P1':
        return const Color(0xFFEF4444);
      case 'P2':
        return const Color(0xFFF59E0B);
      case 'P3':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    String? tempZone = _filters['zone'];
    String? tempType = _filters['type'];
    String? tempPriority = _filters['priority'];
    String? tempStatus = _filters['status'];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF8F9FA)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF005B96).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.filter_list, color: Color(0xFF005B96), size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Filtrer les tâches",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005B96),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: tempZone,
                  decoration: _buildInputDecoration('Zone', Icons.location_on_outlined),
                  items: [null, 'Zone A', 'Zone B', 'Zone C', 'Data Center A']
                      .map((zone) => DropdownMenuItem(value: zone, child: Text(zone ?? 'Tous', style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) => tempZone = value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: tempType,
                  decoration: _buildInputDecoration('Type', Icons.category_outlined),
                  items: [null, 'Maintenance', 'Qualité', 'Sécurité']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type ?? 'Tous', style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) => tempType = value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: tempPriority,
                  decoration: _buildInputDecoration('Priorité', Icons.priority_high_outlined),
                  items: [null, 'P1', 'P2', 'P3']
                      .map((priority) => DropdownMenuItem(value: priority, child: Text(priority ?? 'Tous', style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) => tempPriority = value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: tempStatus,
                  decoration: _buildInputDecoration('Statut', Icons.info_outlined),
                  items: [null, 'New', 'In Progress', 'Completed']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status ?? 'Tous', style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) => tempStatus = value,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF005B96),
                          side: const BorderSide(color: Color(0xFF005B96)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Annuler", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _filters = {
                              'zone': tempZone,
                              'type': tempType,
                              'priority': tempPriority,
                              'status': tempStatus,
                            };
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005B96),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Appliquer", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAssignDialog(Map<String, dynamic> task) {
    String? selectedEmployee = task['assignedTo'];
    String? selectedStatus = task['status'];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF8F9FA)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: Color(0xFF10B981), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        "Assigner: ${task['id']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005B96),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedEmployee,
                  decoration: _buildInputDecoration('Employé', Icons.person_outlined),
                  items: ['Hassan Fayech', 'Sara Mansouri', 'Amina Zaki', 'Youssef Benali', 'Non assigné']
                      .map((emp) => DropdownMenuItem(value: emp, child: Text(emp, style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) => selectedEmployee = value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: _buildInputDecoration('Statut', Icons.info_outlined),
                  items: ['New', 'In Progress', 'Completed']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status, style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) => selectedStatus = value,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF005B96),
                          side: const BorderSide(color: Color(0xFF005B96)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Annuler", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            final index = _tasks.indexWhere((t) => t['id'] == task['id']);
                            _tasks[index]['assignedTo'] = selectedEmployee;
                            _tasks[index]['status'] = selectedStatus;
                            _tasks[index]['auditLog'].add({
                              'timestamp': DateTime.now().toString(),
                              'action': 'Assignée à $selectedEmployee, Statut: $selectedStatus',
                              'user': _adminName,
                            });
                          });
                          Navigator.pop(context);
                          _notifyEmployee(task['id'], selectedEmployee, selectedStatus);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Assigner", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String priority = 'P3';
    String type = 'Maintenance';
    String zone = '';
    String status = 'New';
    String assignedTo = 'Non assigné';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.add_task, color: const Color(0xFF005B96)),
                  const SizedBox(width: 8),
                  Text('Ajouter une tâche'),
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
                      value: type,
                      decoration: _buildInputDecoration('Type', Icons.category_outlined),
                      items: ['Maintenance', 'Qualité', 'Sécurité']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => type = value!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: priority,
                      decoration: _buildInputDecoration('Priorité', Icons.priority_high_outlined),
                      items: ['P1', 'P2', 'P3']
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => priority = value!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) => zone = value,
                      decoration: InputDecoration(
                        labelText: 'Zone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: _buildInputDecoration('Statut', Icons.info_outlined),
                      items: ['New', 'In Progress', 'Completed']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => status = value!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: assignedTo,
                      decoration: _buildInputDecoration('Assignée à', Icons.person_outlined),
                      items: ['Hassan Fayech', 'Sara Mansouri', 'Amina Zaki', 'Youssef Benali', 'Non assigné']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => assignedTo = value!),
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
                      _addNewTask(
                        title: titleController.text,
                        description: descriptionController.text,
                        type: type,
                        priority: priority,
                        zone: zone,
                        status: status,
                        assignedTo: assignedTo,
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

  void _showCalendarDialog() {
    // Placeholder for calendar view
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF8F9FA)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Calendrier des tâches",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005B96),
                ),
              ),
              const SizedBox(height: 16),
              // Placeholder for calendar widget (e.g., table_calendar package could be used)
              const Text("Calendrier global des tâches et événements (à implémenter)"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005B96),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Fermer"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewTask({
    required String title,
    required String description,
    required String type,
    required String priority,
    required String zone,
    required String status,
    required String assignedTo,
  }) {
    final id = 'TASK${_tasks.length + 1}'.padLeft(7, '0');
    setState(() {
      _tasks.insert(0, {
        'id': id,
        'title': title,
        'date': DateTime.now().toString(),
        'zone': zone,
        'type': type,
        'priority': priority,
        'status': status,
        'assignedTo': assignedTo,
        'description': description,
        'isCompleted': false,
        'auditLog': [
          {'timestamp': DateTime.now().toString(), 'action': 'Tâche créée', 'user': _adminName},
        ],
      });
    });
    _notifyEmployee(id, assignedTo, status);
  }

  void _deleteTask(Map<String, dynamic> task) {
    setState(() {
      _tasks.removeWhere((t) => t['id'] == task['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tâche supprimée')),
    );
  }

  void _notifyEmployee(String id, String? employee, String? status) {
    print('Notification sent to $employee for task $id with status $status');
    // Implement actual notification logic here
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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