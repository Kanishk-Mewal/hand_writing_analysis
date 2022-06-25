import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';
import 'scroll_test.dart';

void main() => runApp(MyApp());

HandSignatureControl control =HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 1.0,
);

ValueNotifier<String?> svg = ValueNotifier<String?>(null);

ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);

ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  bool get scrollTest => false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Write Something',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: scrollTest
            ? ScrollTest()
            : SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints.expand(),
                            color: Colors.white,
                            child: HandSignaturePainterView(
                              control: control,
                              type: SignatureDrawType.shape,
                            ),
                          ),
                          CustomPaint(
                            painter: DebugSignaturePainterCP(
                              control: control,
                              cp: false,
                              cpStart: false,
                              cpEnd: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CupertinoButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          control.clear();
                          svg.value = null;
                          rawImage.value = null;
                          rawImageFit.value = null;
                        },
                        child: const Text('Clear'),
                      ),
                      CupertinoButton(
                        color: Colors.redAccent,
                        onPressed: () async {
                          svg.value = control.toSvg(
                            color: Colors.blueGrey,
                            size: const Size(512, 256),
                            strokeWidth: 10.0,
                            maxStrokeWidth: 10.0,
                            type: SignatureDrawType.shape,
                          );

                          rawImage.value = await control.toImage(
                            color: Colors.blueAccent,
                            background: Colors.greenAccent,
                            fit: false,
                          );

                          rawImageFit.value = await control.toImage(
                            color: Colors.blueAccent,
                            background: Colors.greenAccent,
                          );
                        },
                        child: Text('Export'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}