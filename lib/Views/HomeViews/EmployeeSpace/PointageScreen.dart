import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../navigation/CustomBottomNavigationBar.dart';
import 'QRScannerScreen.dart';

class PointageScreen extends StatefulWidget {
  const PointageScreen({super.key});

  @override
  State<PointageScreen> createState() => _PointageScreenState();
}

class _PointageScreenState extends State<PointageScreen> {
  // State variables
  int _currentIndex = 1;
  final String _currentStatus = "Présent";
  final String _lastCheckInTime = "07:53";
  final String _currentZone = "Zone A";
  final List<Map<String, String>> _checkInHistory = [
    {'date': '22/07/2025', 'time': '07:53', 'zone': 'Zone A', 'type': 'Entrée site'},
    {'date': '21/07/2025', 'time': '16:30', 'zone': 'Zone B', 'type': 'Sortie zone'},
    {'date': '21/07/2025', 'time': '08:15', 'zone': 'Zone B', 'type': 'Entrée site'},
    {'date': '20/07/2025', 'time': '17:00', 'zone': 'Point de rassemblement', 'type': 'Point de rassemblement'},
    {'date': '20/07/2025', 'time': '07:45', 'zone': 'Zone A', 'type': 'Entrée site'},
  ];

  Future<void> _scanQRCode() async {
    final PermissionStatus permission = await Permission.camera.request();

    switch (permission) {
      case PermissionStatus.granted:
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const QRScannerScreen()),
          );
        }
        break;
      case PermissionStatus.denied:
        _showPermissionDialog();
        break;
      case PermissionStatus.permanentlyDenied:
        _showSettingsDialog();
        break;
      default:
        break;
    }
  }

  void _showPermissionDialog() {
    _showDialog(
      title: 'Autorisation caméra',
      icon: Icons.camera_alt,
      content: 'L\'accès à la caméra est nécessaire pour scanner les codes QR. Veuillez autoriser l\'accès dans les paramètres.',
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _scanQRCode();
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005B96)),
          child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showSettingsDialog() {
    _showDialog(
      title: 'Paramètres requis',
      icon: Icons.settings,
      content: 'L\'autorisation caméra a été refusée de façon permanente. Veuillez l\'activer manuellement dans les paramètres de l\'application.',
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005B96)),
          child: const Text('Ouvrir paramètres', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showDialog({
    required String title,
    required IconData icon,
    required String content,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(icon, color: const Color(0xFF005B96)),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(content),
          actions: actions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
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
        "Mon Pointage",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white, size: 24),
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
                _buildStatusCard(),
                const SizedBox(height: 32),
                _buildHistorySection(),
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

  Widget _buildStatusCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(Icons.badge_outlined, "Statut du jour"),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: _currentStatus == "Présent" ? const Color(0xFF7ED957) : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  _currentStatus,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _currentStatus == "Présent" ? const Color(0xFF7ED957) : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.access_time, "Dernier pointage", _lastCheckInTime),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.place, "Zone actuelle", _currentZone),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardHeader(Icons.history, "Historique des pointages"),
        const SizedBox(height: 16),
        Container(
          decoration: _cardDecoration(),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _checkInHistory.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              final entry = _checkInHistory[index];
              return ListTile(
                leading: Icon(
                  entry['type'] == 'Entrée site'
                      ? Icons.login
                      : entry['type'] == 'Sortie zone'
                      ? Icons.logout
                      : Icons.place,
                  color: const Color(0xFF005B96),
                ),
                title: Text(
                  "${entry['date']} - ${entry['time']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF005B96),
                  ),
                ),
                subtitle: Text(
                  "${entry['type']} ${entry['zone'] != '' ? '(${entry['zone']})' : ''}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: _fabDecoration(),
      child: FloatingActionButton(
        onPressed: _scanQRCode,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 24),
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
            fontSize: 18,
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