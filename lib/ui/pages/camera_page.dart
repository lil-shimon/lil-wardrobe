import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {

  /// CameraDescriptionのインスタンスを取得
  final CameraDescription camera;

  /// カメラで撮影された画像へのローカルパス
  final ValueChanged didProvideImagePath;

  CameraPage({ Key? key, required this.camera, required this.didProvideImagePath }) 
    : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  /// 初期化
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          /// Future Builder -> カメラ映像のpreview or circularを表示
          return (snapshot.connectionState == ConnectionState.done)
            ? CameraPreview(this._controller) 
            : Center(child: CircularProgressIndicator());
        },
      ),
      /// Buttonが押されると写真を撮る
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera), onPressed: _takePicture
      ),
    );
  }

  void _takePicture() async {
    try {
      await _initializeControllerFuture;
      
      final tmpDirectory = await getTemporaryDirectory();
      final filePath = "${Datetime.now().millisecondsSinceEpoch}.png";
      final path = join(tmpDirectory.path, filePath);

      await _controller.takePicture(path);

      widget.didProvideImagePath(path);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
