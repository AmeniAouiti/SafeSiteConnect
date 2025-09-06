import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late String _adminName;
  late String _adminEmail;
  late String _adminPhone;
  final String _adminRole = "Administrateur Principal";
  final String _adminLastLogin = "Aujourd'hui à 08:30";
  bool _notificationsEnabled = true;
  bool _emailAlerts = true;
  bool _smsAlerts = false;
  bool _twoFactorAuth = true;

  // Mock data for admin actions history
  final List<Map<String, dynamic>> _adminActions = [
    {
      'action': 'Modification des droits d\'accès',
      'target': 'Utilisateur: Ahmed Ben Salah',
      'time': '12/04/2025 - 14:22',
      'ip': '192.168.1.45',
    },
    {
      'action': 'Génération rapport sécurité',
      'target': 'Zone A & B',
      'time': '12/04/2025 - 09:15',
      'ip': '192.168.1.45',
    },
    {
      'action': 'Désactivation compte',
      'target': 'Utilisateur: Sami Trabelsi',
      'time': '11/04/2025 - 17:40',
      'ip': '192.168.1.45',
    },
    {
      'action': 'Mise à jour mot de passe',
      'target': 'Compte personnel',
      'time': '10/04/2025 - 20:05',
      'ip': '192.168.1.45',
    },
  ];

  // Image source (peut être asset ou chemin de fichier)
  String _profileImagePath = 'assets/amd.jpg';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _adminName = "Admin Principal";
    _adminEmail = "admin.principal@entreprise.com";
    _adminPhone = "+216 71 123 456";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 32),
              _buildPersonalInfoSection(),
              const SizedBox(height: 32),
              _buildNotificationSecuritySection(),
              const SizedBox(height: 32),
              _buildHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF005B96),
      elevation: 0,
      title: const Text(
        "Profil Administrateur",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showChangePhotoDialog(context),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF005B96), width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: _profileImagePath.startsWith('assets/')
                        ? AssetImage(_profileImagePath) as ImageProvider
                        : FileImage(File(_profileImagePath)),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF005B96),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _adminName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005B96),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            _adminRole,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(Icons.person, "Informations Personnelles"),
            const SizedBox(height: 20),
            _buildEditableInfoRow("Nom complet", _adminName, () => _showEditDialog("Nom complet", _adminName, (value) => setState(() => _adminName = value))),
            _buildEditableInfoRow("Email", _adminEmail, () => _showEditDialog("Email", _adminEmail, (value) => setState(() => _adminEmail = value))),
            _buildEditableInfoRow("Téléphone", _adminPhone, () => _showEditDialog("Téléphone", _adminPhone, (value) => setState(() => _adminPhone = value))),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSecuritySection() {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(Icons.security, "Notifications & Sécurité"),
            const SizedBox(height: 20),
            _buildSwitchListTile(
              title: "Notifications activées",
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
            ),
            if (_notificationsEnabled) ...[
              _buildSwitchListTile(
                title: "Alertes par email",
                value: _emailAlerts,
                onChanged: (value) => setState(() => _emailAlerts = value),
              ),
              _buildSwitchListTile(
                title: "Alertes par SMS",
                value: _smsAlerts,
                onChanged: (value) => setState(() => _smsAlerts = value),
              ),
            ],
            const Divider(height: 32, color: Colors.grey),
            _buildSwitchListTile(
              title: "Authentification à deux facteurs",
              value: _twoFactorAuth,
              onChanged: (value) => setState(() => _twoFactorAuth = value),
            ),
            const SizedBox(height: 16),
            if (_twoFactorAuth)
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
                        "Un code vous sera envoyé par SMS ou email à chaque connexion.",
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showChangePasswordDialog(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF005B96)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.password),
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

  Widget _buildHistorySection() {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(Icons.history, "Historique des Actions"),
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _adminActions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final action = _adminActions[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action['action'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF005B96),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        action['target'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              action['time'],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "IP: ${action['ip']}",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _generateAndExportPDF(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005B96),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text(
                  "Exporter l'historique complet (PDF)",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DIALOGUES

  void _showEditDialog(String field, String currentValue, ValueChanged<String> onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Modifier $field"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text("$field ne peut pas être vide")),
                );
              }
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Changer le mot de passe"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                decoration: const InputDecoration(labelText: "Mot de passe actuel", border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newController,
                decoration: const InputDecoration(labelText: "Nouveau mot de passe", border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmController,
                decoration: const InputDecoration(labelText: "Confirmer le nouveau mot de passe", border: OutlineInputBorder()),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              if (newController.text.isEmpty || confirmController.text.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text("Veuillez remplir tous les champs")),
                );
                return;
              }
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
                );
                return;
              }
              // Simuler changement
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text("Mot de passe mis à jour avec succès")),
              );
              Navigator.pop(ctx);
            },
            child: const Text("Mettre à jour"),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePhotoDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Changer la photo de profil"),
        content: const Text("Souhaitez-vous choisir une image depuis la galerie ou prendre une photo ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  _profileImagePath = image.path;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Photo de profil mise à jour")),
                );
              }
            },
            child: const Text("Galerie"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final XFile? image = await _picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                setState(() {
                  _profileImagePath = image.path;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Photo prise et enregistrée")),
                );
              }
            },
            child: const Text("Appareil photo"),
          ),
          // Optionnel : Réinitialiser à l'image par défaut
          TextButton(
            onPressed: () {
              setState(() {
                _profileImagePath = 'assets/amd.jpg';
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Photo réinitialisée")),
              );
            },
            child: const Text("Réinitialiser"),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndExportPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  children: [
                    pw.Text(
                      "Historique des Actions Administratives",
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      "Généré le: ${DateTime.now().toString().split('.')[0]}",
                      style: pw.TextStyle(fontSize: 12, color: PdfColors.grey500),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Container(
                      width: double.infinity,
                      color: PdfColors.grey200,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Row(
                        children: [
                          pw.Expanded(child: pw.Text("Action", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text("Cible", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text("Date/Heure", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(child: pw.Text("IP", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    ..._adminActions.map((action) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 6),
                      decoration: pw.BoxDecoration(
                        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
                      ),
                      child: pw.Row(
                        children: [
                          pw.Expanded(child: pw.Text(action['action'])),
                          pw.Expanded(child: pw.Text(action['target'])),
                          pw.Expanded(child: pw.Text(action['time'])),
                          pw.Expanded(child: pw.Text(action['ip'])),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "historique_actions_admin_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
  }

  // WIDGETS UTILITAIRES

  Widget _buildSectionHeader(IconData icon, String title) {
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
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005B96),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableInfoRow(String label, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              child: Text(
                "$label:",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF005B96),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Flexible(
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
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF005B96),
      contentPadding: EdgeInsets.zero,
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
}