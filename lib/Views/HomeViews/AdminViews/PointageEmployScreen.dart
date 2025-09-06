import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'CustomBottomNavigationBarAdmin.dart';

class PointageEmployScreen extends StatefulWidget {
  const PointageEmployScreen({super.key});

  @override
  State<PointageEmployScreen> createState() => _PointageEmployScreenState();
}

class _PointageEmployScreenState extends State<PointageEmployScreen> with TickerProviderStateMixin {
  int _currentIndex = 4;
  final String _adminName = "Admin Principal";
  String _searchQuery = '';
  String _sortBy = 'date';
  late TabController _tabController;
  String? _selectedSite;

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
      'date': '2025-09-06 08:00',
      'site': 'Data Center A',
      'type': 'Entrée',
      'exitTime': '2025-09-06 17:00',
      'isPresent': true,
      'auditLog': [
        {'timestamp': '2025-09-06 08:05', 'action': 'Pointage enregistré', 'user': 'Système'},
      ],
    },
    {
      'id': 'ATT002',
      'employee': 'Sara Mansouri',
      'date': '2025-09-06 08:15',
      'site': 'Zone C',
      'type': 'Entrée',
      'exitTime': null,
      'isPresent': true,
      'auditLog': [
        {'timestamp': '2025-09-06 08:20', 'action': 'Pointage enregistré', 'user': 'Système'},
      ],
    },
    {
      'id': 'ATT003',
      'employee': 'Amina Zaki',
      'date': '2025-09-06 09:00',
      'site': 'Zone A',
      'type': 'Entrée',
      'exitTime': '2025-09-06 16:30',
      'isPresent': false,
      'auditLog': [
        {'timestamp': '2025-09-06 09:05', 'action': 'Pointage enregistré', 'user': 'Système'},
        {'timestamp': '2025-09-06 16:35', 'action': 'Sortie enregistrée', 'user': 'Système'},
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredAttendances {
    var result = _attendances.where((a) {
      final matchesSearch = _searchQuery.isEmpty ||
          a['employee'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSite = _selectedSite == null || a['site'] == _selectedSite;
      final isPresent = a['isPresent'] == true;
      return matchesSearch && matchesSite && isPresent;
    }).toList();

    if (_sortBy == 'date') {
      result.sort((a, b) => b['date'].compareTo(a['date']));
    } else {
      result.sort((a, b) => a['employee'].compareTo(b['employee']));
    }
    return result;
  }

  List<Map<String, dynamic>> get attendanceHistory {
    var result = _attendances.where((a) {
      final matchesSearch = _searchQuery.isEmpty ||
          a['employee'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSite = _selectedSite == null || a['site'] == _selectedSite;
      return matchesSearch && matchesSite;
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
    final presentCount = filteredAttendances.length;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(presentCount),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBarAdmin(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  AppBar _buildAppBar(int presentCount) {
    return AppBar(
      backgroundColor: const Color(0xFF005B96),
      elevation: 0,
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Suivi des présences",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                _adminName,
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          if (presentCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
                child: Text(presentCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
        IconButton(icon: const Icon(Icons.filter_list, color: Colors.white, size: 24), onPressed: _showFilterDialog),
        IconButton(icon: const Icon(Icons.download, color: Colors.white, size: 24), onPressed: _showExportOptions),
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildSearchSection(),
              const SizedBox(height: 16),
              _buildTabsSection(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderGradient() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF005B96), Color(0xFFF8F9FA)]),
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: const [Tab(text: "Présences en cours"), Tab(text: "Historique")],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            padding: const EdgeInsets.all(16),
            child: TabBarView(controller: _tabController, children: [_buildPresenceTab(), _buildHistoryTab()]),
          ),
        ],
      ),
    );
  }

  Widget _buildPresenceTab() {
    if (filteredAttendances.isEmpty) return _buildEmptyState();
    return ListView.separated(
      itemCount: filteredAttendances.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _buildPresenceCard(filteredAttendances[i]),
    );
  }

  Widget _buildHistoryTab() {
    if (attendanceHistory.isEmpty) return _buildEmptyState();
    return ListView.separated(
      itemCount: attendanceHistory.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _buildHistoryCard(attendanceHistory[i]),
    );
  }

  Widget _buildPresenceCard(Map<String, dynamic> attendance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.login, color: Color(0xFF10B981), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(attendance['id'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                  Text(attendance['employee'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.access_time, "Entrée", attendance['date']),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.place, "Site", attendance['site']),
        ]),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> attendance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF005B96).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(attendance['type'] == 'Entrée' ? Icons.login : Icons.logout, color: const Color(0xFF005B96), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(attendance['id'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                  Text(attendance['employee'], style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.access_time, "Entrée", attendance['date']),
          if (attendance['exitTime'] != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, "Sortie", attendance['exitTime']),
          ],
          const SizedBox(height: 8),
          _buildInfoRow(Icons.place, "Site", attendance['site']),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.category, "Type", attendance['type']),
          const SizedBox(height: 16),
          Column(
            children: attendance['auditLog'].map<Widget>((log) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF10B981)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(log['timestamp'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        Text('${log['action']} par ${log['user']}', style: const TextStyle(fontSize: 14, color: Color(0xFF005B96))),
                      ])),
                ]),
              );
            }).toList(),
          )
        ]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.search_off, size: 40, color: Colors.grey)),
        const SizedBox(height: 12),
        Text("Aucun pointage trouvé", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        Text("Essayez d'autres filtres ou termes de recherche", style: TextStyle(fontSize: 14, color: Colors.grey[500])),
      ]),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFF8F9FA)]),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
    );
  }

  void _showFilterDialog() {
    String? tempSite = _selectedSite;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFF8F9FA)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFF005B96).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.filter_list, color: Color(0xFF005B96), size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text("Filtrer par site", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
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
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF005B96),
                          side: const BorderSide(color: Color(0xFF005B96)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Annuler", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedSite = tempSite;
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
                ]),
              ]),
            )),
      ),
    );
  }

  void _showExportOptions() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFF8F9FA)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF005B96).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.download, color: Color(0xFF005B96), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: const Text(
                      "Options d'exportation",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showEmployeeSelectionDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005B96),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Rapport individuel", style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSiteSelectionDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005B96),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Rapport par site", style: TextStyle(fontSize: 14)),
              ),
            ])),
      ),
    );
  }

  // ✅ CORRIGÉ : Popup Sélection Employé
  void _showEmployeeSelectionDialog() {
    String? selectedEmployee;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7, // Limite la hauteur
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFF8F9FA)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFF005B96).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.person, color: Color(0xFF005B96), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: const Text(
                            "Sélectionner un employé",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedEmployee,
                      decoration: _buildInputDecoration('Employé', Icons.person_outlined),
                      items: _attendances.map((e) => e['employee'] as String).toSet().toList()
                          .map((emp) => DropdownMenuItem(value: emp, child: Text(emp, style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (value) => selectedEmployee = value,
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
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
                            if (selectedEmployee != null) {
                              _exportEmployeeHistoryPdf(selectedEmployee!);
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005B96),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Exporter", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ CORRIGÉ : Popup Sélection Site
  void _showSiteSelectionDialog() {
    String? selectedSite = _selectedSite;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7, // Limite la hauteur
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFF8F9FA)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFF005B96).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.location_on_outlined, color: Color(0xFF005B96), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: const Text(
                            "Sélectionner un site",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedSite,
                      decoration: _buildInputDecoration('Site', Icons.location_on_outlined),
                      items: ['Zone A', 'Zone B', 'Zone C', 'Data Center A']
                          .map((site) => DropdownMenuItem(value: site, child: Text(site, style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (value) => selectedSite = value,
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
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
                            if (selectedSite != null) {
                              _exportSiteHistoryPdf(selectedSite!);
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez sélectionner un site")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005B96),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Exporter", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exportEmployeeHistoryPdf(String employee) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final filteredRecords = _attendances.where((r) {
      final date = DateTime.parse(r['date']);
      return r['employee'] == employee &&
          date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          date.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    await _generateHistoryPdf(filteredRecords, 'Historique des pointages de $employee');
  }

  Future<void> _exportSiteHistoryPdf(String site) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final filteredRecords = _attendances.where((r) {
      final date = DateTime.parse(r['date']);
      return r['site'] == site &&
          date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          date.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    await _generateHistoryPdf(filteredRecords, 'Historique des pointages du site $site');
  }

  Future<void> _generateHistoryPdf(List<Map<String, dynamic>> records, String title) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          if (records.isEmpty)
            pw.Center(
              child: pw.Text('Aucun pointage trouvé.', style: const pw.TextStyle(fontSize: 14)),
            )
          else
            pw.Table.fromTextArray(
              headers: ['Employé', 'Date', 'Entrée', 'Sortie', 'Site', 'Type'],
              data: records.map((record) {
                final date = DateTime.parse(record['date']);
                final exitDate = record['exitTime'] != null ? DateTime.tryParse(record['exitTime']) : null;
                return [
                  record['employee'],
                  DateFormat('dd/MM/yyyy').format(date),
                  DateFormat('HH:mm').format(date),
                  exitDate != null ? DateFormat('HH:mm').format(exitDate) : 'Non enregistrée',
                  record['site'],
                  record['type'],
                ];
              }).toList(),
              border: pw.TableBorder.all(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: pw.EdgeInsets.all(8),
            ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final fileName = title.toLowerCase().replaceAll(' ', '_') + '_history_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ouverture du PDF: ${result.message}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF généré avec succès')));
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 18, color: Colors.grey[600]),
      const SizedBox(width: 8),
      Text("$label: ", style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
      Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF005B96), fontWeight: FontWeight.w600)),
    ]);
  }
}