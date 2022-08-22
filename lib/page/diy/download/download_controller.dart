import 'package:flutter/material.dart';

import 'download_manager.dart';

///
class DownloadController extends ChangeNotifier {
  ///
  final String networkUrl;

  ///
  String key;

  ///
  String filePath;

  ///
  double per;

  ///
  int currentSize;

  ///
  int allSize;

  ///
  DownloadStatus state = DownloadStatus.init;

  ///
  DownloadController({@required this.networkUrl});

  ///
  void load({String suffix}) async {
    DownloadManager.getInstance().requestDownloadByChunks(
        url: networkUrl,
        suffix: suffix,
        callback: (downloadResult) {
          switch (downloadResult.status) {
            case DownloadStatus.success:
              state = DownloadStatus.success;
              filePath = downloadResult.filePath;
              key = downloadResult.urlKey;
              break;
            case DownloadStatus.loading:
              state = DownloadStatus.loading;
              per = downloadResult.currentSize / downloadResult.allSize;
              currentSize = downloadResult.currentSize;
              allSize = downloadResult.allSize;
              break;
            case DownloadStatus.fail:
              state = DownloadStatus.fail;
              break;
          }
          notifyListeners();
        });

  }


}
