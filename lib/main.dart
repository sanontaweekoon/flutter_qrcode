import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:my_qrcode/generate_qrcode_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final title = "QR Code";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            child: Image.asset(
              'assets/logo.png',
              width: 500,
              height: 250,
              alignment: AlignmentDirectional.topCenter,
            ),
            padding: EdgeInsets.all(10),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  _buildScan(context: context),
                  SizedBox(
                    width: 20,
                  ),
                  _buildGenerator(context: context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildScan({BuildContext context}) => Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/qr-code-2.png",
              width: 110,
              height: 110,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Colors.tealAccent[700],
              textColor: Colors.white,
              child: Text("SCAN"),
              onPressed: (){
                scanQRCode(context: context);
              } ,
            )
          ],
        ),
      );

  _buildGenerator({BuildContext context}) {
    final text = "GENERATOR";
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            "assets/qr-code.png",
            width: 110,
            height: 110,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            color: Colors.deepOrangeAccent,
            textColor: Colors.white,
            child: Text(text),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GenerateQRCodePage(
                          title: text,
                        )),
              );
            },
          )
        ],
      ),
    );
  }

  Future scanQRCode({BuildContext context}) async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      showAlertDialog(result: barcode.rawContent, context: context);
    } on PlatformException catch (exception) {
      if (exception.code == BarcodeScanner.cameraAccessDenied) {
        showAlertDialog(
            result: 'not grant permission to open the camera',
            context: context);
      } else {
        print('Unknown error: $exception');
      }
    } catch (exception) {
      print('Unknown error: $exception');
    }
  }

  showAlertDialog({BuildContext context, String result}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Result"),
          content: Text(result),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }
}
