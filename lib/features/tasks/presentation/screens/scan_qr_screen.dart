import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/ops_header.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1827),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OpsHeader(
              title: 'Scan QR',
              fallbackRoute: AppRoutes.home,
              dark: true,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF111B2B),
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
                child: Column(
                  children: [
                    const _ScannerFrame(),
                    const SizedBox(height: 34),
                    const Text(
                      'Position the QR code within the frame to\nscan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 34),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38),
                      ),
                      child: const Icon(
                        Icons.flashlight_on_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerFrame extends StatelessWidget {
  const _ScannerFrame();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4B5563), width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: const [
            Center(
              child: Icon(Icons.qr_code_2, size: 86, color: Color(0xFF8B919D)),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 170,
              child: Divider(height: 1, color: Color(0xFF4B5563)),
            ),
          ],
        ),
      ),
    );
  }
}
