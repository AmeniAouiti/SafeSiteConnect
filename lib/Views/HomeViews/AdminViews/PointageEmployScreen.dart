import 'package:flutter/material.dart';
import 'CustomBottomNavigationBarAdmin.dart';

class PointageEmployScreen extends StatefulWidget {
  const PointageEmployScreen({super.key});

  @override
  State<PointageEmployScreen> createState() => _PointageEmployScreenState();
}

class _PointageEmployScreenState extends State<PointageEmployScreen> with TickerProviderStateMixin {
  int _currentIndex = 4; // Assuming attendance is the 5th tab
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

  final List<Map<String, dynamic>> _attendances = [
    {
      'id': 'ATT001',
      'employee': 'Hassan Fayech',
      'date': '2025-09-05 08:00',
      'site': 'Data Center A',
      'type': 'Entrée',
      'status': 'Validé',
      'notes': 'Arrivée à l’heure.',
      'auditLog': [
        {'timestamp': '2025-09-05 08:05', 'action': 'Pointage enregistré', 'user': 'Système'},
      ],
    },
    {
      'id': 'ATT002',
      'employee': 'Sara Mansouri',
      'date': '2025-09-05 08:15',
      'site': 'Zone C',
      'type': 'Entrée',
      'status': 'En attente',
      'notes': 'En attente de validation.',
      'auditLog': [
        {'timestamp': '2025-09-05 08:20', 'action': 'Pointage enregistré', 'user': 'Système'},
      ],
    },
  ];

  Map<String, String?> _filters = {
    'site': null,
    'type': null,
    'status': null,
  };

  List<Map<String, dynamic>> get filteredAttendances {
    var result = _attendances.where((attendance) {
      final matchesSearch = _searchQuery.isEmpty ||
          attendance['employee'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          attendance['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilters = (_filters['site'] == null || attendance['site'] == _filters['site']) &&
          (_filters['type'] == null || attendance['type'] == _filters['type']) &&
          (_filters['status'] == null || attendance['status'] == _filters['status']);
      return matchesSearch && matchesFilters;
    }).toList();

    if (_sortBy == 'date') {
      result.sort((a, b) => b['date'].compareTo(a['date']));
    } else {
      result.sort((a, b) => a['employee'].compareTo(b['employee']));
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
    final pendingCount = _attendances.where((att) => att['status'] == 'En attente').length;
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
                "Suivi des pointages",
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
            const PopupMenuItem(value: 'employee', child: Text('Trier par employé')),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white, size: 24),
          onPressed: _showFilterDialog,
        ),
        IconButton(
          icon: const Icon(Icons.download, color: Colors.white, size: 24),
          onPressed: _exportReport,
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
          hintText: "Rechercher par employé ou ID...",
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
                Tab(text: "Pointages"),
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
                _buildAttendancesTab(),
                _buildAuditTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendancesTab() {
    return filteredAttendances.isEmpty
        ? _buildEmptyState()
        : ListView.separated(
      itemCount: filteredAttendances.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildAttendanceCard(filteredAttendances[index]),
    );
  }

  Widget _buildAuditTab() {
    return filteredAttendances.isEmpty
        ? _buildEmptyState()
        : ListView.separated(
      itemCount: filteredAttendances.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildAuditCard(filteredAttendances[index]),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> attendance) {
    Color statusColor = _getStatusColor(attendance['status']);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            attendance['status'] == 'En attente' ? Colors.yellow.shade50 : Colors.white,
            attendance['status'] == 'En attente' ? Colors.yellow.shade100.withOpacity(0.3) : const Color(0xFFF8F9FA),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: attendance['status'] == 'En attente' ? Colors.yellow.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: attendance['status'] == 'En attente' ? Colors.yellow.withOpacity(0.1) : Colors.black.withOpacity(0.08),
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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    attendance['type'] == 'Entrée' ? Icons.login : Icons.logout,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance['id'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005B96),
                        ),
                      ),
                      Text(
                        attendance['employee'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005B96),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    attendance['status'] == 'Validé' ? Icons.check_circle : Icons.pending,
                    color: statusColor,
                    size: 20,
                  ),
                  onPressed: () => _validateAttendance(attendance),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.access_time, "Date", attendance['date']),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.place, "Site", attendance['site']),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.category, "Type", attendance['type']),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.info, "Statut", attendance['status']),
            const SizedBox(height: 12),
            Text(
              attendance['notes'],
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
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditAttendanceDialog(attendance),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005B96),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Modifier", style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteAttendance(attendance),
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

  Widget _buildAuditCard(Map<String, dynamic> attendance) {
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
                        attendance['id'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005B96),
                        ),
                      ),
                      Text(
                        attendance['employee'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: attendance['auditLog'].map<Widget>((log) {
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
            "Aucun pointage trouvé",
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
        onPressed: _showAddAttendanceDialog,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.access_time, color: Colors.white, size: 24),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Validé':
        return const Color(0xFF10B981);
      case 'En attente':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    String? tempSite = _filters['site'];
    String? tempType = _filters['type'];
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
                      "Filtrer les pointages",
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
                  value: tempSite,
                  decoration: _buildInputDecoration('Site', Icons.location_on_outlined),
                  items: [null, 'Zone A', 'Zone B', 'Zone C', 'Data Center A']
                      .map((site) => DropdownMenuItem(value: site, child: Text(site ?? 'Tous', style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) => tempSite = value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: tempType,
                  decoration: _buildInputDecoration('Type', Icons.category_outlined),
                  items: [null, 'Entrée', 'Sortie']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type ?? 'Tous', style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (value) => tempType = value,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: tempStatus,
                  decoration: _buildInputDecoration('Statut', Icons.info_outlined),
                  items: [null, 'Validé', 'En attente']
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
                              'site': tempSite,
                              'type': tempType,
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

  void _showAddAttendanceDialog() {
    final employeeController = TextEditingController();
    final notesController = TextEditingController();
    String type = 'Entrée';
    String site = '';
    String status = 'En attente';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.access_time, color: const Color(0xFF005B96)),
                  const SizedBox(width: 8),
                  Text('Ajouter un pointage'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: employeeController.text.isEmpty ? null : employeeController.text,
                      decoration: _buildInputDecoration('Employé', Icons.person_outlined),
                      items: ['Hassan Fayech', 'Sara Mansouri', 'Amina Zaki', 'Youssef Benali']
                          .map((emp) => DropdownMenuItem(value: emp, child: Text(emp)))
                          .toList(),
                      onChanged: (value) => employeeController.text = value!,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) => site = value,
                      decoration: InputDecoration(
                        labelText: 'Site',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: _buildInputDecoration('Type', Icons.category_outlined),
                      items: ['Entrée', 'Sortie']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => type = value!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: _buildInputDecoration('Statut', Icons.info_outlined),
                      items: ['Validé', 'En attente']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => status = value!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
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
                    if (employeeController.text.isNotEmpty && site.isNotEmpty) {
                      _addNewAttendance(
                        employee: employeeController.text,
                        site: site,
                        type: type,
                        status: status,
                        notes: notesController.text,
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

  void _showEditAttendanceDialog(Map<String, dynamic> attendance) {
    final employeeController = TextEditingController(text: attendance['employee']);
    final notesController = TextEditingController(text: attendance['notes']);
    String? site = attendance['site'];
    String type = attendance['type'];
    String status = attendance['status'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.edit, color: const Color(0xFF005B96)),
                  const SizedBox(width: 8),
                  Text('Modifier pointage: ${attendance['id']}'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: employeeController.text,
                      decoration: _buildInputDecoration('Employé', Icons.person_outlined),
                      items: ['Hassan Fayech', 'Sara Mansouri', 'Amina Zaki', 'Youssef Benali']
                          .map((emp) => DropdownMenuItem(value: emp, child: Text(emp)))
                          .toList(),
                      onChanged: (value) => employeeController.text = value!,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) => site = value,
                      decoration: InputDecoration(
                        labelText: 'Site',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: attendance['site'],
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: _buildInputDecoration('Type', Icons.category_outlined),
                      items: ['Entrée', 'Sortie']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => type = value!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: _buildInputDecoration('Statut', Icons.info_outlined),
                      items: ['Validé', 'En attente']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (value) => setDialogState(() => status = value!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
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
                    if (employeeController.text.isNotEmpty && site!.isNotEmpty) {
                      setState(() {
                        final index = _attendances.indexWhere((a) => a['id'] == attendance['id']);
                        _attendances[index] = {
                          'id': attendance['id'],
                          'employee': employeeController.text,
                          'date': attendance['date'],
                          'site': site,
                          'type': type,
                          'status': status,
                          'notes': notesController.text,
                          'auditLog': attendance['auditLog']..add({
                            'timestamp': DateTime.now().toString(),
                            'action': 'Pointage modifié',
                            'user': _adminName,
                          }),
                        };
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005B96),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Modifier', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addNewAttendance({
    required String employee,
    required String site,
    required String type,
    required String status,
    required String notes,
  }) {
    final id = 'ATT${_attendances.length + 1}'.padLeft(7, '0');
    setState(() {
      _attendances.insert(0, {
        'id': id,
        'employee': employee,
        'date': DateTime.now().toString(),
        'site': site,
        'type': type,
        'status': status,
        'notes': notes,
        'auditLog': [
          {'timestamp': DateTime.now().toString(), 'action': 'Pointage enregistré', 'user': _adminName},
        ],
      });
    });
  }

  void _validateAttendance(Map<String, dynamic> attendance) {
    setState(() {
      final index = _attendances.indexWhere((a) => a['id'] == attendance['id']);
      _attendances[index]['status'] = 'Validé';
      _attendances[index]['auditLog'].add({
        'timestamp': DateTime.now().toString(),
        'action': 'Pointage validé',
        'user': _adminName,
      });
    });
  }

  void _deleteAttendance(Map<String, dynamic> attendance) {
    setState(() {
      _attendances.removeWhere((a) => a['id'] == attendance['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pointage supprimé')),
    );
  }

  void _exportReport() {
    // Placeholder for export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportation en PDF/Excel en cours...')),
    );
    // Implement actual export logic here (e.g., using pdf or excel package)
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