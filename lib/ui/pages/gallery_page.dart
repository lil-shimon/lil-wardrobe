import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GalleryPage extends StatelessWidget {
  /// 単純に画像を表示するWidget
  /// StatelessWidget
  
  /// CameraFlowのshouldLogOutに接続 [VoidCallback]
  final VoidCallback shouldLogOut;

  /// CameraFlowのshouldShowCameraに接続 [VoidCallback]
  final VoidCallback shouldShowCamera;

  GalleryPage({ Key? key, required this.shouldLogOut, required this.shouldShowCamera }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        actions: [
          Padding(
            /// ログアウトボタン
            /// Appbar内にある。
            /// タップするとshouldLogOut[VoidCallback]が呼び出される
            padding: const EdgeInsets.all(8),
            child: GestureDetector(child: Icon(Icons.logout), onTap: shouldLogOut)
            )
        ],
      ),
      /// このボタンを押すとshouldShowCamera[VoidCallback]が発動しカメラが表示される
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt), onPressed: shouldShowCamera
      ),
      body: Container(child: _galleryGrid()),
    );
  }

  /// 画像をグリッド表示するメインのWidget.
  /// 画像は格子状に2列で表示する
  /// このグリッドでは3つのアイテムがハードコードしている
  Widget _galleryGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
      itemCount: 3,
      itemBuilder: (context, index) {
        return Placeholder();
      }
    );
  }
}