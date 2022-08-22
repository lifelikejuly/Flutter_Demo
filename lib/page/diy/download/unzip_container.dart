import 'dart:io';

import 'package:flutter/material.dart';

import 'unzip_mamager.dart';

///
typedef UnzipLayoutBuilder = Widget Function(
    BuildContext context, File file);

///
class UnzipContainer extends StatefulWidget {
  ///
  final String fileKey;

  ///
  final String filePath;

  ///
  final String findFileName;

  ///
  final UnzipLayoutBuilder builder;
  ///
  final Widget initChild;

  ///
  UnzipContainer({
    @required this.fileKey,
    @required this.filePath,
    @required this.findFileName,
    @required this.builder,
    this.initChild,
  });

  @override
  State<UnzipContainer> createState() => _UnzipContainerState();
}

class _UnzipContainerState extends State<UnzipContainer> {
  String get fileKey => widget.fileKey;

  String get zipPath => widget.filePath;

  String get findFileName => widget.findFileName;

  UnzipLayoutBuilder get builder => widget.builder;

  Widget get initChild => widget.initChild;

  bool unzipFinish = false;
  String unzipFilePath = "";

  @override
  void initState() {
    super.initState();
    _unzip();
  }

  ///
  void _unzip() async {
    UnzipManager.getInstance().toUnzip(zipPath, fileKey, findFileName, (unzipFilePath) {
      if(mounted){
        this.unzipFilePath = unzipFilePath;
        setState(() {
          unzipFinish = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return unzipFinish ? builder(context, File(unzipFilePath)) :  initChild ?? Container();
  }
}
