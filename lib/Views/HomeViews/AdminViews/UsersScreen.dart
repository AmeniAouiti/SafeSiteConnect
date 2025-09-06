import 'package:flutter/material.dart';
import 'CustomBottomNavigationBarAdmin.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> with TickerProviderStateMixin {
  int _currentIndex = 1;
  final String _adminName = "Admin Principal";
  String _searchQuery = '';
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

  final List<Map<String, dynamic>> _employees = [
    {
      'id': 'EMP001',
      'name': 'Hassan Fayech',
      'role': 'Technicien',
      'status': 'Actif',
      'email': 'hassan.fayech@company.com',
      'password': 'pass123',
      'permissions': ['Pointage', 'Rapport'],
      'department': 'Technique',
      'joinDate': '2023-01-15',
    },
    {
      'id': 'EMP002',
      'name': 'Amina Zaki',
      'role': 'Manager',
      'status': 'En congé',
      'email': 'amina.zaki@company.com',
      'password': 'pass456',
      'permissions': ['Pointage', 'Rapport', 'Gestion équipes'],
      'department': 'Management',
      'joinDate': '2022-03-20',
    },
    {
      'id': 'EMP003',
      'name': 'Youssef Benali',
      'role': 'Opérateur',
      'status': 'Inactif',
      'email': 'youssef.benali@company.com',
      'password': 'pass789',
      'permissions': ['Pointage'],
      'department': 'Production',
      'joinDate': '2023-06-10',
    },
    {
      'id': 'EMP004',
      'name': 'Sara Mansouri',
      'role': 'Superviseur',
      'status': 'Actif',
      'email': 'sara.mansouri@company.com',
      'password': 'pass101',
      'permissions': ['Pointage', 'Rapport', 'Supervision'],
      'department': 'Qualité',
      'joinDate': '2022-11-05',
    },
  ];

  List<Map<String, dynamic>> get filteredEmployees {
    if (_searchQuery.isEmpty) return _employees;
    return _employees.where((employee) =>
        employee['name'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBarAdmin(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF005B96),
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gestion utilisateurs",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            _adminName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [
        GestureDetector(
          onTap: () => _showAddEmployeeDialog(),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF7ED957),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  "Ajouter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderGradient(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      height: 40,
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
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: "Rechercher par nom...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 2,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: const [
                Tab(text: "Employés"),
                Tab(text: "Permissions"),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmployeesTab(),
                _buildPermissionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesTab() {
    return filteredEmployees.isEmpty
        ? _buildEmptyState()
        : ListView.separated(
      itemCount: filteredEmployees.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildEmployeeCard(filteredEmployees[index]),
    );
  }

  Widget _buildPermissionsTab() {
    return ListView.separated(
      itemCount: _employees.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildPermissionCard(_employees[index]),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    Color statusColor = _getStatusColor(employee['status']);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.person, color: statusColor, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005B96),
                      ),
                    ),
                    Text(
                      '${employee['role']} • ${employee['department']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  employee['status'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    employee['email'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEditEmployeeDialog(employee),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005B96),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text("Modifier", style: TextStyle(fontSize: 11)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showPermissionsDialog(employee),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF005B96),
                    side: const BorderSide(color: Color(0xFF005B96)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.security, size: 14),
                  label: const Text("Permissions", style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(Map<String, dynamic> employee) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF005B96).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person, color: Color(0xFF005B96), size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005B96),
                      ),
                    ),
                    Text(
                      '${employee['role']} • ${employee['department']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF005B96), size: 18),
                onPressed: () => _showPermissionsDialog(employee),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Permissions accordées:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: employee['permissions'].map<Widget>((permission) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        permission,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
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
            "Aucun employé trouvé",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          Text(
            "Essayez un autre nom",
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
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
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Actif':
        return const Color(0xFF10B981);
      case 'En congé':
        return const Color(0xFFF59E0B);
      case 'Inactif':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  void _showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String? selectedRole;
    String? selectedDepartment;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF8F9FA)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7ED957).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.person_add, color: Color(0xFF7ED957), size: 16),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Ajouter employé",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005B96),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: _buildInputDecoration('Nom', Icons.person_outline),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: _buildInputDecoration('Email', Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  decoration: _buildInputDecoration('Mot de passe', Icons.lock_outline),
                  obscureText: true,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: _buildInputDecoration('Rôle', Icons.work_outline),
                  items: ['Technicien', 'Manager', 'Opérateur', 'Superviseur']
                      .map((role) => DropdownMenuItem(value: role, child: Text(role, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (value) => selectedRole = value,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: _buildInputDecoration('Dépt.', Icons.business_outlined),
                  items: ['Technique', 'Management', 'Production', 'Qualité']
                      .map((dept) => DropdownMenuItem(value: dept, child: Text(dept, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (value) => selectedDepartment = value,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF005B96),
                          side: const BorderSide(color: Color(0xFF005B96)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Annuler", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty &&
                              selectedRole != null &&
                              selectedDepartment != null) {
                            setState(() {
                              _employees.add({
                                'id': 'EMP${_employees.length + 1}'.padLeft(7, '0'),
                                'name': nameController.text,
                                'role': selectedRole!,
                                'status': 'Actif',
                                'email': emailController.text,
                                'password': passwordController.text,
                                'permissions': ['Pointage'],
                                'department': selectedDepartment!,
                                'joinDate': DateTime.now().toIso8601String().split('T')[0],
                              });
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7ED957),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Ajouter", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
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

  void _showEditEmployeeDialog(Map<String, dynamic> employee) {
    final nameController = TextEditingController(text: employee['name']);
    final emailController = TextEditingController(text: employee['email']);
    final passwordController = TextEditingController(text: employee['password']);
    String? selectedRole = employee['role'];
    String? selectedDepartment = employee['department'];
    String? selectedStatus = employee['status'];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF8F9FA)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF005B96).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.edit, color: Color(0xFF005B96), size: 16),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "Modifier ${employee['name']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005B96),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: _buildInputDecoration('Nom', Icons.person_outline),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: _buildInputDecoration('Email', Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  decoration: _buildInputDecoration('Mot de passe', Icons.lock_outline),
                  obscureText: true,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: _buildInputDecoration('Rôle', Icons.work_outline),
                  items: ['Technicien', 'Manager', 'Opérateur', 'Superviseur']
                      .map((role) => DropdownMenuItem(value: role, child: Text(role, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (value) => selectedRole = value,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  decoration: _buildInputDecoration('Dépt.', Icons.business_outlined),
                  items: ['Technique', 'Management', 'Production', 'Qualité']
                      .map((dept) => DropdownMenuItem(value: dept, child: Text(dept, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (value) => selectedDepartment = value,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: _buildInputDecoration('Statut', Icons.info_outline),
                  items: ['Actif', 'En congé', 'Inactif']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (value) => selectedStatus = value,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF005B96),
                          side: const BorderSide(color: Color(0xFF005B96)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Annuler", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty &&
                              selectedRole != null &&
                              selectedDepartment != null &&
                              selectedStatus != null) {
                            setState(() {
                              final index = _employees.indexWhere((e) => e['id'] == employee['id']);
                              _employees[index] = {
                                'id': employee['id'],
                                'name': nameController.text,
                                'role': selectedRole!,
                                'status': selectedStatus!,
                                'email': emailController.text,
                                'password': passwordController.text,
                                'permissions': employee['permissions'],
                                'department': selectedDepartment!,
                                'joinDate': employee['joinDate'],
                              };
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005B96),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Modifier", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
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

  void _showPermissionsDialog(Map<String, dynamic> employee) {
    final availablePermissions = ['Pointage', 'Rapport', 'Gestion équipes', 'Supervision'];
    List<String> selectedPermissions = List.from(employee['permissions']);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF8F9FA)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.security, color: Color(0xFF10B981), size: 16),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "Perms: ${employee['name']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005B96),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...availablePermissions.map((permission) {
                  return CheckboxListTile(
                    title: Text(permission, style: const TextStyle(fontSize: 12)),
                    value: selectedPermissions.contains(permission),
                    activeColor: const Color(0xFF10B981),
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedPermissions.add(permission);
                        } else {
                          selectedPermissions.remove(permission);
                        }
                      });
                    },
                  );
                }),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF005B96),
                          side: const BorderSide(color: Color(0xFF005B96)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Annuler", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            final index = _employees.indexWhere((e) => e['id'] == employee['id']);
                            _employees[index]['permissions'] = selectedPermissions;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Enregistrer", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
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

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
      prefixIcon: Icon(icon, size: 16, color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    );
  }
}