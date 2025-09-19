import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider/Providertheme.dart';
import '../../../navigation/CustomBottomNavigationBar.dart';

class ProfilEmployePage extends StatefulWidget {
  const ProfilEmployePage({super.key});

  @override
  State<ProfilEmployePage> createState() => _ProfilEmployePageState();
}

class _ProfilEmployePageState extends State<ProfilEmployePage> {
  // State variables
  int _currentIndex = 4;

  final Map<String, dynamic> _employeeData = {
    'fullName': 'Hassan Fayech',
    'role': 'Électricien',
    'site': 'Chantier Nord',
    'email': 'hassan.fayech@safesiteconnect.com',
    'phone': '+216 58 932 240',
    'employeeId': 'EMP-123456',
    'status': 'En service',
    'avatarUrl': 'assets/hassan.jpg',
  };

  // Mock data for personal stats
  final Map<String, dynamic> _stats = {
    'pointages': {'thisMonth': 22, 'absences': 1, 'retards': 2},
    'incidents': {'reported': 3, 'resolved': 2, 'pending': 1},
    'tasks': {'assigned': 15, 'completed': 12, 'overdue': 1},
  };

  void _showEditProfileDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _buildEditProfileSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      appBar: _buildAppBar(themeProvider),
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  AppBar _buildAppBar(ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: const Color(0xFF005B96),
      elevation: 0,
      title: const Text(
        "Mon Profil",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(
            theme.brightness == Brightness.dark ? Icons.wb_sunny : Icons.nightlight_round,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderGradient(),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 32),
                _buildInfoCard(),
                const SizedBox(height: 32),
                _buildStatsCard(),
                const SizedBox(height: 32),
                _buildSecurityCard(),
                const SizedBox(height: 32),
                _buildActionButtons(),
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

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF7ED957), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFF7ED957),
            child: _employeeData['avatarUrl'] == null
                ? const Icon(Icons.person, size: 70, color: Colors.white)
                : ClipOval(
              child: Image.asset(
                _employeeData['avatarUrl'],
                fit: BoxFit.cover,
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.person, size: 70, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _employeeData['fullName'] ?? 'Nom non disponible',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF005B96),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _employeeData['role'] ?? 'Rôle non spécifié',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
        if (_employeeData['site'] != null) ...[
          const SizedBox(height: 8),
          Text(
            'Chantier: ${_employeeData['site']}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.email, "Email", _employeeData['email'] ?? 'Non disponible'),
            const Divider(height: 20, color: Colors.grey),
            _buildInfoRow(Icons.phone, "Téléphone", _employeeData['phone'] ?? 'Non disponible'),
            const Divider(height: 20, color: Colors.grey),
            _buildInfoRow(Icons.badge, "Matricule", _employeeData['employeeId'] ?? 'Non disponible'),
            const Divider(height: 20, color: Colors.grey),
            _buildInfoRow(
              Icons.work,
              "Statut",
              _employeeData['status'] ?? 'Non disponible',
              valueColor: _employeeData['status'] == 'En service'
                  ? const Color(0xFF7ED957)
                  : _employeeData['status'] == 'En pause'
                  ? Colors.orange
                  : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      decoration: _cardDecoration(),
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
                    color: const Color(0xFF005B96).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bar_chart, color: Color(0xFF005B96), size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Statistiques Personnelles",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005B96),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildStatItem("Pointages ce mois", "${_stats['pointages']['thisMonth']}", Icons.calendar_today, Colors.blue),
            const SizedBox(height: 12),
            _buildStatItem("Incidents signalés", "${_stats['incidents']['reported']}", Icons.warning, Colors.orange),
            const SizedBox(height: 12),
            _buildStatItem("Tâches terminées", "${_stats['tasks']['completed']}/${_stats['tasks']['assigned']}", Icons.task, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    bool _notificationsEnabled = true;
    bool _emailAlerts = true;
    bool _twoFactorAuth = false;

    return Container(
      decoration: _cardDecoration(),
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
                    color: const Color(0xFF005B96).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.security, color: Color(0xFF005B96), size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Paramètres & Sécurité",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005B96),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSwitchRow("Notifications activées", _notificationsEnabled, (value) {}),
            if (_notificationsEnabled) ...[
              const SizedBox(height: 12),
              _buildSwitchRow("Alertes par email", _emailAlerts, (value) {}),
            ],
            const SizedBox(height: 16),
            _buildSwitchRow("Authentification à 2 facteurs", _twoFactorAuth, (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(value ? "2FA activée" : "2FA désactivée")),
              );
            }),
            if (_twoFactorAuth) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Un code vous sera envoyé à chaque connexion.",
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Ouvrir changement de mot de passe
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Changement de mot de passe simulé")),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF005B96)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.password, size: 18),
                label: const Text(
                  "Changer le mot de passe",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF005B96)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showEditProfileDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005B96),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: const Text(
              "Modifier mes informations",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/signin'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF005B96), width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "Déconnexion",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF005B96),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditProfileSheet() {
    final TextEditingController emailController = TextEditingController(text: _employeeData['email']);
    final TextEditingController phoneController = TextEditingController(text: _employeeData['phone']);

    return Padding(
      padding: EdgeInsets.all(20.0) + EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  child: const Icon(Icons.edit, color: Color(0xFF005B96), size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Modifier le profil",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005B96),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler', style: TextStyle(color: Color(0xFF005B96))),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _employeeData['email'] = emailController.text;
                      _employeeData['phone'] = phoneController.text;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profil mis à jour")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005B96),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // UTILS

  BoxDecoration _cardDecoration() {
    final theme = Theme.of(context);
    return BoxDecoration(
      gradient: theme.brightness == Brightness.dark
          ? const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2D2D2D), Color(0xFF1E1E1E)],
      )
          : const LinearGradient(
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

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF005B96)),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 16,
            color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: valueColor ?? const Color(0xFF005B96),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF005B96),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF005B96),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF005B96),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}