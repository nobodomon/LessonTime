import "package:flutter/material.dart";
import "package:camera/camera.dart";
import 'dart:async';

class QRPage extends StatefulWidget{
  @override
  _QRPageState createState() => new _QRPageState();
}
class _QRPageState extends State<QRPage> {
  List<CameraDescription> cameras;
  CameraController controller;

  Future<Null> main() async {
    cameras = await availableCameras();
  }
  @override
  void initState() {
    super.initState();
    controller = new CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Card(
            color: Colors.white,
            elevation: 3.0,
            child: new Column(
              children: <Widget>[
                const ListTile(
                  leading: const Icon(Icons.album),
                  title: const Text('The Enchanted Nightingale'),
                  subtitle: const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                ),
                buildCam(),
              ],

            )
          )
        ],
      );
  }
/*
  Container buildCam(){
    Widget build(BuildContext context) {
      if (!controller.value.isInitialized) {
        return new Container();
      }
      return new AspectRatio(
          aspectRatio:
          controller.value.aspectRatio,
          child: new Container(
            child : new CameraPreview(controller)
          ));
    }
  }
  */
}