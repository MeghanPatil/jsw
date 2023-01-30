import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../common-methods.dart';

class QRViewExample extends StatefulWidget {

  final void Function(Barcode?) callback;
  const QRViewExample({Key? key, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    print('inside reassemble');
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    print('inside initstate');
    super.initState();
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR"),backgroundColor: Colors.blueAccent,elevation: 0,actions: [
        IconButton(
          color: Colors.white,
          icon: FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              return snapshot.data == false ? const Icon(Icons.flash_off, color: Colors.white) : const Icon(Icons.flash_on, color: Colors.white);

            },
          ),
          iconSize: 32.0,
          onPressed: () async {
            await controller?.toggleFlash();
            setState(() {});
          },
        ),
        IconButton(
          color: Colors.white,
          icon: FutureBuilder(
            future: controller?.getCameraInfo(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return describeEnum(snapshot.data!) != "front" ? const Icon(
                    Icons.camera_rear, color: Colors.white) : const Icon(
                    Icons.camera_front, color: Colors.white);
              }else{
                return Container();
              }
              },
          ),
          iconSize: 32.0,
          onPressed: () async {
            await controller?.flipCamera();
            setState(() {});
          },
        ),
      ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                          'Barcode Type: ${describeEnum(
                              result!.format)}   Data: ${result!.code.toString().toUpperCase()}'),
                    )
                  else
                    const Text('You will get here scanned result'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('Pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('Resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(result?.code!=null){
                              widget.callback(result);
                              Navigator.of(context).pop();
                              //insertCodes(CodeDataModel(id: 0, codeFormat: result!.format.toString(), codeContent: result!.code.toString())).whenComplete(() => print("codes :: ${codes()}"));
                            }else{
                              showToast("Please scan code before saving","");
                            }

                          },
                          child: const Text('Save',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) async {
      await  controller.pauseCamera();

      setState(() {
        result = scanData;
      });
      showToast('Scanned data : ${result!.code.toString().toUpperCase()}',"qr");
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}