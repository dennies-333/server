import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

  

class SerialPortParser {
  static Map<String, dynamic> parse(String data) {
    return jsonDecode(data) as Map<String, dynamic>;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Object tran;
  late WebSocketChannel channel; // Define the WebSocket channel

  @override
  void initState() {
    super.initState();

    tran = Object(
      fileName: "assets/3d/cube/light.obj",
      lighting: true,
      
    );
    tran.rotation.setValues(0, 0, 0);
    tran.position.setValues(0, 0, 0);
    tran.updateTransform();

    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8002/ws/data/'));
    channel.stream.listen((data) {
      // Parse the incoming JSON data
      Map<String, dynamic> jsonData = jsonDecode(data);
      print(jsonData);

      //Update tran position and rotation based on the incoming data
      tran.position.setValues(
        double.parse(jsonData['objectX']),
        double.parse(jsonData['objectY']),
        double.parse(jsonData['objectZ']),
      );
      tran.rotation.setValues(
        double.parse(jsonData['gyroX']),
        double.parse(jsonData['gyroY']),
        double.parse(jsonData['gyroZ']),
      );
      tran.updateTransform();

      // Call setState to rebuild the UI with updated position and rotation
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Flutter 3D"),
      ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            "assets/images/belly_big.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Cube with the 3D objects
          Cube(
            onSceneCreated: (Scene scene) {
              scene.world.add(tran);
              //scene.world.add(shark2);
              scene.camera.zoom = 10;
            },
          ),
        ],
      ),
    );
  }
}
