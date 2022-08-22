
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
///
class FileUtils{


  ///
  static Future<String> rootPath({String resourcePath = "FlutterRes"}) async {
    /// android 根目录：getExternalFilesDir/version
    /// iOS 根目录：Caches/version
    Directory tempDirectory;
    if (Platform.isIOS) {
      tempDirectory = await getTemporaryDirectory();
    } else {
      tempDirectory = await getExternalStorageDirectory();
    }
    return path.join(tempDirectory.path, resourcePath);
  }

  /// 文件是否已存在
  static bool checkFileExist(String filePath){
    File file = File(filePath);
    // 源文件已下载存在
    return file != null && file.existsSync();
  }
}