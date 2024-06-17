import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanCodeSection extends StatefulWidget {
  const ScanCodeSection({super.key});

  @override
  ScanCodeSectionState createState() => ScanCodeSectionState();
}

class ScanCodeSectionState extends State<ScanCodeSection> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? scannedCode; // Результат сканирования

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Обработка результата сканирования
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedCode = scanData;
      });
      // Здесь вы можете добавить логику обработки отсканированного кода
      // Например, открыть ссылку, отобразить данные и т.д.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5, // Занимает большую часть экрана
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300, // Размер области сканирования
            ),
          ),
        ),
        Expanded(
          flex: 1, // Занимает меньшую часть экрана
          child: Center(
            child: (scannedCode != null)
                ? Text('Scanned code: ${scannedCode!.code}') // Отображение отсканированного кода
                : const Text('Scan a code'),
          ),
        ),
      ],
    );
  }
}
