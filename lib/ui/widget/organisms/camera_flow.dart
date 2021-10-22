import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CameraFlow extends StatefulWidget {
  /// ユーザーがログアウトして状態が元通りになった時にトリガーされる
  final VoidCallback shouldLogOut;

  CameraFlow({ required this.shouldLogOut });

  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow>{
  /// カメラを表示する、しない
  bool _shouldShowCamera = false;

  /// _shouldShowCamera[bool]をトリガーにして、Navigatorが更新される
  /// computedプロパティを使用して、現在の状態に適切なナビゲーションスタックを返す
  List<MaterialPage> get _pages {
    return [
      MaterialPage(child: Placeholder()),
      if (_shouldShowCamera)
      MaterialPage(child: Placeholder())
    ];
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
}