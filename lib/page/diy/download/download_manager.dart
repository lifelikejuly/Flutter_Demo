import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'encrypt_utils.dart';
import 'file_utils.dart';

///
class DownloadResult {
  ///
  String urlKey;

  ///
  int allSize;

  ///
  int currentSize;

  ///
  String filePath;

  ///
  DownloadStatus status;

  ///
  String msg;

  ///
  DownloadResult();

  ///
  static DownloadResult success(String key,String filePath) {
    return DownloadResult()
      ..urlKey = key
      ..filePath = filePath
      ..status = DownloadStatus.success;
  }

  ///
  static DownloadResult loading(int allSize, int currentSize) {
    return DownloadResult()
      ..allSize = allSize
      ..currentSize = currentSize
      ..status = DownloadStatus.loading;
  }

  ///
  static DownloadResult fail(String msg) {
    return DownloadResult()
      ..msg = msg
      ..status = DownloadStatus.fail;
  }
}

///
enum DownloadStatus {
  ///
  init,

  ///
  loading,

  ///
  success,

  ///
  fail,
}

///
typedef DownloadCallback = void Function(DownloadResult downloadResult);

typedef _DownloadReadyCallback = void Function(bool tempFileExist,String tempFilePath,String filePath);

/// 异步下载文件
/// 异步分片下载文件
/// 断点续传功能
/// 已有文件不下载处理（正式文件是下载成功后命名，下载过程中命名为temp）
///
/// 下载器推荐下载大小控制在10M以内 保证下载成功率
/// 过大文件加载不适合以下发形式出现
///
class DownloadManager {
  /// 下载缓存命名
  static final String TEMP = ".temp";

  ///
  static final String CHUNK = ".chunk";

  ///
  static final Dio _dio = Dio();

  ///
  static final Map<String, List<DownloadCallback>> _downloadCachePool =
      <String, List<DownloadCallback>>{};

  static DownloadManager _instance;

  DownloadManager._();

  ///
  static DownloadManager getInstance() {
    _instance ??= DownloadManager._();
    return _instance;
  }

  /// 断点续下
  void requestDirectDownload(
      {@required String url,
      @required DownloadCallback callback,
      String suffix}) async {
    _download(url, callback, suffix);
  }

  /// 分段断点续下
  void requestDownloadByChunks(
      {@required String url,
      @required DownloadCallback callback,
      String suffix}) async {
    const int firstChunkSize = 102;
    const int maxChunk = 4;
    _downloadReady(url,callback,suffix,(tempFileExist,fileTempPath,filePath) async{
      List<int> chunksProgress = <int>[];
      // 分片下载
      Response response;
      try{
        response = await _downloadChunk(
            url, filePath, 0, firstChunkSize, 0, 0, chunksProgress);
      }catch(e){
        _callbackDownloadPool(
            EncryptUtils.toMD5(url), DownloadResult.fail("requestDownloadByChunks异常 ：${e?.toString()}"));
        return;
      }
      if (response != null && response.statusCode == 206) {
        try{
          // 支持分段下载
          int total = int.parse(response.headers
              .value(HttpHeaders.contentRangeHeader)
              .split('/')
              .last);
          int reserved = total -
              int.parse(response.headers.value(Headers.contentLengthHeader));
          int chunk = (reserved / firstChunkSize).ceil() + 1;
          if (chunk > 1) {
            int chunkSize = firstChunkSize;
            if (chunk > maxChunk + 1) {
              chunk = maxChunk + 1;
              chunkSize = (reserved / maxChunk).ceil();
            }
            List<Future> futures = <Future>[];
            for (int i = 0; i < maxChunk; ++i) {
              int start = firstChunkSize + i * chunkSize;
              futures.add(_downloadChunk(url, filePath, start, start + chunkSize,
                  i + 1, total, chunksProgress));
            }
            await Future.wait(futures);
          }
          await _mergeTempFiles(filePath, chunk);
          String key = EncryptUtils.toMD5(url);
          _callbackDownloadPool(
              key, DownloadResult.success(key, filePath));
        }catch(e){
          _callbackDownloadPool(
              EncryptUtils.toMD5(url), DownloadResult.fail("requestDownloadByChunks下载异常"));
        }
      } else {
        requestDirectDownload(url: url, callback: null, suffix: suffix);
      }
    });
  }

  /// 下载基类方法逻辑
  void _download(String url, DownloadCallback callback, String suffix) async {
    _downloadReady(url,callback,suffix,(tempFileExist,fileTempPath,filePath) {
      if (tempFileExist) {
        _breakPointDownload(url, fileTempPath);
      } else {
        _directDownload(url, fileTempPath);
      }
    });

  }

  /// 直连下载
  void _directDownload(String url, String savePath) {
    try{
      _dio.download(url, savePath, onReceiveProgress: (currentSize, allSize) async{
        if(currentSize == allSize){
          File tempFile = File(savePath);
          String resultPath = savePath.replaceAll('.temp', '');
          await tempFile.rename(resultPath);
          String key = EncryptUtils.toMD5(url);
          _callbackDownloadPool(
              key , DownloadResult.success(key,resultPath));
        }else{
          _callbackDownloadPool(
              EncryptUtils.toMD5(url), DownloadResult.loading(allSize, currentSize));
        }
      });
    }catch(e){
      _callbackDownloadPool(
          EncryptUtils.toMD5(url), DownloadResult.fail("_directDownload异常 ${e?.toString()}"));
    }

  }

  /// 断点下载方法
  void _breakPointDownload(
      String url, String savePath) async {
    File tempFile = File(savePath);
    int downloadFileSize = tempFile.lengthSync();
    Map<String, dynamic> map = {
      "range": "bytes=$downloadFileSize-",
    };
    try {
      Response<ResponseBody> responseBody = await _dio.get<ResponseBody>(
        url,
        options: Options(
          responseType: ResponseType.stream,
          followRedirects: false,
          headers: map,
        ),
      );

      RandomAccessFile raf = tempFile.openSync(mode: FileMode.append);
      // 文件大小
      int total = int.parse(responseBody.headers
          .value(HttpHeaders.contentRangeHeader)
          .split("/")
          .last);
      // 已下载大小
      int received = downloadFileSize;

      Stream<Uint8List> stream = responseBody.data.stream;
      StreamSubscription<Uint8List> subscription;
      subscription = stream.listen(
        (data) {
          raf.writeFromSync(data);
          received += data.length;
          _callbackDownloadPool(
              EncryptUtils.toMD5(url), DownloadResult.loading(total, received));
        },
        onDone: () async {
          String resultPath = savePath.replaceAll('.temp', '');
          await tempFile.rename(resultPath);
          await raf.close();
          String key = EncryptUtils.toMD5(url);
          _callbackDownloadPool(
              key , DownloadResult.success(key,resultPath));
          await subscription?.cancel();
        },
        onError: (e) async {
          _callbackDownloadPool(
              EncryptUtils.toMD5(url), DownloadResult.fail(" _breakPointDownload download fail"));
          await subscription?.cancel();
        },
        cancelOnError: true,
      );
    } on DioError catch (error) {
      _callbackDownloadPool(
          EncryptUtils.toMD5(url), DownloadResult.fail("DioError ${error?.message ?? ""}" ));
    }
  }

  Future<Response> _downloadChunk(
      String url,
      String savePath,
      int start,
      int end,
      int chunkNum,
      int total,
      List<int> chunksProgress) async {
    chunksProgress.add(0);
    if (chunkNum > 0) {
      // 除了第一段分段 其他分段检查是否下载成功了
      File file = File("$savePath$CHUNK$chunkNum");
      if (file != null && file.existsSync()) {
        chunksProgress[chunkNum] = await file.length();
        _callbackDownloadPool(
            EncryptUtils.toMD5(url),
            DownloadResult.loading(
                total, chunksProgress.reduce((a, b) => a + b)));
        return null;
      }
    }
    --end;
    return _dio.download(
      url,
      "$savePath$TEMP$chunkNum",
      onReceiveProgress: (c, t) async {
        if (c == t) {
          File file = File("$savePath$TEMP$chunkNum");
          await file.rename("$savePath$CHUNK$chunkNum");
        }
        chunksProgress[chunkNum] = c;
        _callbackDownloadPool(
            EncryptUtils.toMD5(url),
            DownloadResult.loading(
                total, chunksProgress.reduce((a, b) => a + b)));
      },
      options: Options(
        headers: {'range': 'bytes=$start-$end'},
      ),
    );
  }

  Future _mergeTempFiles(String saveFilePath, int chunk) async {
    File f = File("${saveFilePath}${CHUNK}0");
    IOSink ioSink = f.openWrite(mode: FileMode.writeOnlyAppend);
    for (int i = 1; i < chunk; i++) {
      File _f = File("$saveFilePath${CHUNK}$i");
      await ioSink.addStream(_f.openRead());
      await _f.delete();
    }
    await ioSink.close();
    await f.rename(saveFilePath);
  }

  bool _addDownloadPool(String urlKey, DownloadCallback callback) {
    if (_downloadCachePool.containsKey(urlKey)) {
      if(callback != null){
        _downloadCachePool[urlKey]?.add(callback);
      }
      return true;
    } else {
      if(callback != null) {
        _downloadCachePool[urlKey] = [callback];
      }
      return false;
    }
  }

  void _callbackDownloadPool(String urlKey, DownloadResult downloadResult,{bool isExist = false}) {
    List<DownloadCallback> callbacks = _downloadCachePool[urlKey];
    if (callbacks?.isNotEmpty ?? false) {
      for (DownloadCallback callback in callbacks) {
        callback?.call(downloadResult);
      }
    }
    if (downloadResult.status == DownloadStatus.success) {
      _downloadCachePool.remove(urlKey);
      if(isExist) return;
    }else if(downloadResult.status == DownloadStatus.fail){
      _downloadCachePool.remove(urlKey);
    }
  }

  void _downloadReady(String url,DownloadCallback callback,String suffix,_DownloadReadyCallback readyCallback) async{
    // 文件md5唯一值
    String urlKey = EncryptUtils.toMD5(url);
    bool exist = _addDownloadPool(urlKey, callback);
    if (exist) return;
    // 父级文档地址
    String parentPath =
        await FileUtils.rootPath(resourcePath: "FlutterDownload");
    // 文件temp地址
    String fileTempPath = "$parentPath/$urlKey$TEMP";
    String filePath = "$parentPath/$urlKey";
    if (suffix?.isNotEmpty ?? false) {
      filePath = "$filePath.$suffix";
    }
    // 源文件已下载存在
    bool originFileExist = FileUtils.checkFileExist(filePath);
    bool tempFileExist = FileUtils.checkFileExist(fileTempPath);
    if (originFileExist) {
      String key = EncryptUtils.toMD5(url);
      _callbackDownloadPool(
          key, DownloadResult.success(key,filePath),isExist:true);
      return;
    }
    readyCallback?.call(tempFileExist,fileTempPath,filePath);
  }
}
