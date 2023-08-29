import 'dart:io' as io;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';

class ScanQRPage extends StatefulWidget {
  Function callback;
  ScanQRPage(this.callback);

  @override
  _ScanQRPage createState() => _ScanQRPage();
}

class _ScanQRPage extends State<ScanQRPage> {
  String? _qrInfo = '-';
  bool _camState = false;

  _qrCallback(String? code) {
    setState(() async {
      _camState = false;

      if (code!.indexOf('travellerinromania.com/?p=') != -1) {
        int nr = code!.indexOf('/?p=');
        globals.poiId = code!.substring(nr + 4);
        _qrInfo = code!.substring(nr + 4);
        widget.callback(6);
      } else {
        _qrInfo = code!;
        dynamic upload = await globals.postData(
            "badqrcode",
            jsonEncode(<String, String?>{
              'code': code!,
            }));
        setState(() {});
      }
    });
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  void initState() {
    super.initState();
    _scanCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _camState
              ? Center(
                  child: Column(children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 130,
                      width: MediaQuery.of(context).size.width - 50,
                      child: QRBarScannerCamera(
                        onError: (context, error) => Text(
                          error.toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                        qrCodeCallback: (code) {
                          if (_camState) {
                            _camState = false;
                            _qrCallback(code);
                          }
                        },
                      ),
                    )
                  ]),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(children: [
                    Text(
                      "Eroare",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Codul QR nu ne apartine !",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ), // Text(
                    const SizedBox(height: 30),
                    Text(
                      "[ " + _qrInfo! + " ]",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    //   ,
                    //   style:
                    //       TextStyle(color: Colors.deepPurple, fontSize: 25.0),
                    //   textAlign: TextAlign.center,
                    // )
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _camState = true;
                        });
                      },
                      child: const Text("REINCEARCA"),
                    ),
                  ]),
                )
        ],
      ),
    );
  }
}
