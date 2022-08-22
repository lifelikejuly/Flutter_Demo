
import 'package:flutter/material.dart';

import 'download_controller.dart';
import 'download_manager.dart';

///
typedef ChildLayoutBuilder = Widget Function(BuildContext context,String filePath);

///
class DownloadContainer extends StatefulWidget {

  /// 加载过程中的状态
  final ImageLoadingBuilder loadingBuilder;

  /// 加载成功后
  final ChildLayoutBuilder layoutBuilder;

  /// 加载失败后
  final ImageErrorWidgetBuilder errorBuilder;

  /// 下载器
  final DownloadController downloadController;
  /// 初始化布局
  final Widget initChild;
  ///
  final Widget errorChild;


  ///
  DownloadContainer({
    @required this.layoutBuilder,
    @required this.downloadController,
    this.loadingBuilder,
    this.errorBuilder,
    this.initChild,
    this.errorChild,
  });

  @override
  State<DownloadContainer> createState() => _DownloadContainerState();
}

class _DownloadContainerState extends State<DownloadContainer> {
  DownloadController get downloadController => widget?.downloadController;


  ChildLayoutBuilder get layoutBuilder => widget.layoutBuilder;

  ImageLoadingBuilder get loadingBuilder => widget.loadingBuilder;
  ImageErrorWidgetBuilder get errorBuilder => widget.errorBuilder;

  Widget get initChild => widget.initChild;

  Widget get errorChild => widget.errorChild;

  @override
  void initState() {
    super.initState();
    downloadController.addListener(_handleChange);
  }

  @override
  Widget build(BuildContext context) {
    if (downloadController == null) {
      return initChild ?? Container();
    }
    switch (downloadController.state) {
      case DownloadStatus.init:
        return initChild ?? Container();
        break;
      case DownloadStatus.success:
        if(layoutBuilder != null){
          return layoutBuilder(context,downloadController.filePath);
        }
        return Container();
        break;
      case DownloadStatus.loading:
        if (loadingBuilder != null) {
          return loadingBuilder(
              context,
              null,
              ImageChunkEvent(
                  cumulativeBytesLoaded: downloadController.currentSize,
                  expectedTotalBytes: downloadController.allSize));
        }
        return Container();
        break;
      case DownloadStatus.fail:
        if (errorBuilder != null) {
          return errorBuilder(
              context,
              null,
              null);
        }
        return errorChild ?? Container();
        break;
    }
    return Container();
  }

  @override
  void didUpdateWidget(DownloadContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (downloadController != oldWidget.downloadController) {
      oldWidget.downloadController.removeListener(_handleChange);
      downloadController.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    downloadController.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    setState(() {});
  }
}
