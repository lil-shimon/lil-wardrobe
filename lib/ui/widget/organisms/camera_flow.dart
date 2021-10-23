import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lil_wardrobe/ui/pages/camera_page.dart';
import 'package:lil_wardrobe/ui/pages/gallery_page.dart';

class CameraFlow extends StatefulWidget {
  /// ユーザーがログアウトして状態が元通りになった時にトリガーされる
  final VoidCallback shouldLogOut;

  CameraFlow({ required this.shouldLogOut });

  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow>{

  /// CameraDescriptionインスタンスを作成
  late CameraDescription _camera;

  /// カメラを表示する、しない
  bool _shouldShowCamera = false;

  /// _shouldShowCamera[bool]をトリガーにして、Navigatorが更新される
  /// computedプロパティを使用して、現在の状態に適切なナビゲーションスタックを返す
  List<MaterialPage> get _pages {
    return [
      MaterialPage(child: GalleryPage(
        shouldLogOut: widget.shouldLogOut,
        shouldShowCamera: () => _toggleCameraOpen(true),
      )),
      if (_shouldShowCamera)
      MaterialPage(
        /// カメラページはカメラで初期化
        /// 写真が撮られた時にimagePathを返す
        /// 写真を撮ったらカメラを閉じる
        child: CameraPage(
          camera: _camera,
          didProvideImagePath: (imagePath) {
            this._toggleCameraOpen(false);
          }
        )
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    /// CameraFlowStateが初期化したらすぐ呼ぶ
    _getCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  /// カメラを表示するかしないか。
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      this._shouldShowCamera = isOpen;
    });
  }

  /// _cameraを取得し初期化する関数
  void _getCamera() async {
    final cameraList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      this._camera = firstCamera;
    });
  }
}