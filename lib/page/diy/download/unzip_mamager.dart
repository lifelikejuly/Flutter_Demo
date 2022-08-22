import 'dart:io';

import 'package:archive/archive_io.dart';

///
typedef UnzipCallback = void Function(String unzipFilePath);

///
class UnzipManager{

  static UnzipManager _instance;

  static final Map<String, List<UnzipCallback>> _unZipCachePool =
  <String, List<UnzipCallback>>{};

  UnzipManager._();

  ///
  static UnzipManager getInstance() {
    _instance ??= UnzipManager._();
    return _instance;
  }

  ///
  void toUnzip(String zipPath,String fileKey,String findFileName,UnzipCallback unzipCallback) async{
    _addUnzipPool("$zipPath$findFileName",unzipCallback);
    String unzipFilePath;
    File file = File(zipPath);
    String parentPath = file.parent.path;
    String filePath = "$parentPath/${fileKey}zip";

    // 逻辑需要再加一个temp命名保证是压缩结束成功后
    File unzipFile = File(filePath);
    bool exist = await unzipFile.existsSync();
    if(exist){
      unzipFilePath = "$filePath/$findFileName";
      _callbackUnzipPool("$zipPath$findFileName",unzipFilePath);
      return;
    }

    InputFileStream inputStream = InputFileStream(zipPath);
    Archive archive = ZipDecoder().decodeBuffer(inputStream);
    List<ArchiveFile> files = archive.files;
    String contentJsonFilename;
    for (ArchiveFile file in files) {
      if (file.isFile && file.name.endsWith(findFileName)) {
        contentJsonFilename = file.name;
      }
    }
    try{
      await extractFileToDisk(zipPath, filePath,asyncWrite: true);
    }catch(e){
    }finally{
      unzipFilePath = "$filePath/$contentJsonFilename";
      _callbackUnzipPool("$zipPath$findFileName",unzipFilePath);
    }


  }


  bool _addUnzipPool(String key, UnzipCallback callback) {
    if (_unZipCachePool.containsKey(key)) {
      if(callback != null){
        _unZipCachePool[key]?.add(callback);
      }
      return true;
    } else {
      if(callback != null) {
        _unZipCachePool[key] = [callback];
      }
      return false;
    }
  }

  void _callbackUnzipPool(String key, String unzipFilePath) {
    List<UnzipCallback> callbacks = _unZipCachePool[key];
    if (callbacks?.isNotEmpty ?? false) {
      for (UnzipCallback callback in callbacks) {
        callback?.call(unzipFilePath);
      }
    }
    _unZipCachePool.remove(key);
  }
}