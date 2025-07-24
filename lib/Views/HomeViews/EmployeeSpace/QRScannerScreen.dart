import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isFlashOn = false;
  bool isScanHandled = false; // Pour éviter les scans en double

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    controller.toggleTorch();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  void _handleScan(String? barcode) {
    if (barcode == null || isScanHandled) return;
    isScanHandled = true;

    controller.stop();

    _showScanResult(barcode);
  }

  void _showScanResult(String qrCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7ED957).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF7ED957),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Code QR scanné'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Code détecté:'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                qrCode,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              isScanHandled = false;
              controller.start();
            },
            child: const Text('Scanner à nouveau'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              _processQRCode(qrCode);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005B96),
              foregroundColor: Colors.white,
            ),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _processQRCode(String qrCode) {
    // Traitez le code QR selon votre logique métier (API, stockage, etc.)
    print('Code QR traité: $qrCode');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code QR traité avec succès: $qrCode'),
        backgroundColor: const Color(0xFF7ED957),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Scanner QR Code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
              size: 28,
            ),
            onPressed: _toggleFlash,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isEmpty) return;
                    final String? code = barcodes.first.rawValue;
                    _handleScan(code);
                  },
                ),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Positionnez le code QR dans le cadre pour le scanner',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Alignez le code QR avec le cadre ci-dessus',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
