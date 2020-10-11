import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

extension GifImage on Image {
  static gif({
    @required ImageProvider image,
    Key key,
    ImageFrameBuilder frameBuilder,
    ImageLoadingBuilder loadingBuilder,
    ImageErrorWidgetBuilder errorBuilder,
    String semanticLabel,
    bool excludeFromSemantics = false,
    double width,
    double height,
    Color color,
    BlendMode colorBlendMode,
    BoxFit fit,
    Alignment alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      filterQuality: filterQuality,
      image: image,
    );
  }
}

class GifNetworkImage extends ImageProvider<NetworkImage>
    implements NetworkImage {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  GifNetworkImage(
    this.url, {
    this.repetitionCount = -1,
    this.replayDuration,
    this.reverse = false,
    this.scale = 1.0,
    this.headers,
  }) {
    assert(url != null);
    assert(scale != null);
    // *******Add
    // 加载前必须先检查缓存资源有缓存就清理
    // 否则在缓存中取出codec获取资源不一定是从第一帧图像开始
    if (PaintingBinding.instance.imageCache.containsKey(this)) {
      print("<gifImage> imageCache containsKey ");
      PaintingBinding.instance.imageCache.evict(this, includeLive: true);
    }
  }

  int repetitionCount;

  Duration replayDuration;
  bool reverse;

  @override
  final String url;

  @override
  final double scale;

  @override
  final Map<String, String> headers;

  GifMultiFrameImageStreamCompleter streamCompleter;

  updatePlayConfig({int repetitionCount, Duration replayDuration,bool reverse}) {
    if (repetitionCount != null) {
      this.repetitionCount = repetitionCount;
      this.streamCompleter?.repetitionCount = repetitionCount;
    }
    if (replayDuration != null) {
      this.replayDuration = replayDuration;
      this.streamCompleter?.replayDuration = replayDuration;
    }
    if(reverse != null){
      this.reverse = reverse;
      this.streamCompleter?.reverse = reverse;
    }
  }

  dispose() {
    this.streamCompleter?.clear();
  }

  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImage>(this);
  }

  @override
  ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();
    streamCompleter = GifMultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      reverse: reverse,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<NetworkImage>('Image key', key),
        ];
      },
      replayDuration: replayDuration,
      repetitionCount: repetitionCount,
    );
    return streamCompleter;
  }

  static final HttpClient _sharedHttpClient = HttpClient()
    ..autoUncompress = false;

  static HttpClient get _httpClient {
    HttpClient client = _sharedHttpClient;
    assert(() {
      if (debugNetworkImageHttpClientProvider != null)
        client = debugNetworkImageHttpClientProvider();
      return true;
    }());
    return client;
  }

  Future<ui.Codec> _loadAsync(
    NetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
  ) async {
    try {
      assert(key == this);

      final Uri resolved = Uri.base.resolve(key.url);
      final HttpClientRequest request = await _httpClient.getUrl(resolved);
      headers?.forEach((String name, String value) {
        request.headers.add(name, value);
      });
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        PaintingBinding.instance.imageCache.evict(key);
        throw NetworkImageLoadException(
            statusCode: response.statusCode, uri: resolved);
      }

      final Uint8List bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (int cumulative, int total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: cumulative,
            expectedTotalBytes: total,
          ));
        },
      );
      if (bytes.lengthInBytes == 0)
        throw Exception('NetworkImage is an empty file: $resolved');

      return decode(bytes);
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is NetworkImage && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => ui.hashValues(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NetworkImage')}("$url", scale: $scale)';
}

class GifAssetImage extends GifAssetBundleImageProvider {
  GifAssetImage(
    this.assetName, {
    int repetitionCount = -1,
    Duration replayDuration,
    bool reverse = false,
    this.bundle,
    this.package,
  }) : super(repetitionCount, replayDuration, reverse) {
    assert(assetName != null);
  }

  /// The name of the main asset from the set of images to choose from. See the
  /// documentation for the [AssetImage] class itself for details.
  final String assetName;

  /// The name used to generate the key to obtain the asset. For local assets
  /// this is [assetName], and for assets from packages the [assetName] is
  /// prefixed 'packages/<package_name>/'.
  String get keyName =>
      package == null ? assetName : 'packages/$package/$assetName';

  /// The bundle from which the image will be obtained.
  ///
  /// If the provided [bundle] is null, the bundle provided in the
  /// [ImageConfiguration] passed to the [resolve] call will be used instead. If
  /// that is also null, the [rootBundle] is used.
  ///
  /// The image is obtained by calling [AssetBundle.load] on the given [bundle]
  /// using the key given by [keyName].
  final AssetBundle bundle;

  /// The name of the package from which the image is included. See the
  /// documentation for the [AssetImage] class itself for details.
  final String package;

  // We assume the main asset is designed for a device pixel ratio of 1.0
  static const double _naturalResolution = 1.0;

  updatePlayConfig({int repetitionCount, Duration replayDuration}) {
    if (repetitionCount != null) {
      this.repetitionCount = repetitionCount;
      this.streamCompleter?.repetitionCount = repetitionCount;
    }
    if (replayDuration != null) {
      this.replayDuration = replayDuration;
      this.streamCompleter?.replayDuration = replayDuration;
    }
  }

  dispose() {
    this.streamCompleter?.clear();
  }

  @override
  Future<AssetBundleImageKey> obtainKey(ImageConfiguration configuration) {
    final AssetBundle chosenBundle =
        bundle ?? configuration.bundle ?? rootBundle;
    Completer<AssetBundleImageKey> completer;
    Future<AssetBundleImageKey> result;

    chosenBundle
        .loadStructuredData<Map<String, List<String>>>(
            'AssetManifest.json', _manifestParser)
        .then<void>((Map<String, List<String>> manifest) {
      final String chosenName = _chooseVariant(
        keyName,
        configuration,
        manifest == null ? null : manifest[keyName],
      );
      final double chosenScale = _parseScale(chosenName);
      final AssetBundleImageKey key = AssetBundleImageKey(
        bundle: chosenBundle,
        name: chosenName,
        scale: chosenScale,
      );
      //*** Add
      // 加载前必须先检查缓存资源有缓存就清理
      if (PaintingBinding.instance.imageCache.containsKey(key)) {
        print("<gifImage> imageCache containsKey ");
        PaintingBinding.instance.imageCache.evict(key, includeLive: true);
      }
      if (completer != null) {
        completer.complete(key);
      } else {
        result = SynchronousFuture<AssetBundleImageKey>(key);
      }
    }).catchError((dynamic error, StackTrace stack) {
      assert(completer != null);
      assert(result == null);
      completer.completeError(error, stack);
    });
    if (result != null) {
      return result;
    }
    completer = Completer<AssetBundleImageKey>();
    return completer.future;
  }

  static Future<Map<String, List<String>>> _manifestParser(String jsonData) {
    if (jsonData == null)
      return SynchronousFuture<Map<String, List<String>>>(null);
    final Map<String, dynamic> parsedJson =
        json.decode(jsonData) as Map<String, dynamic>;
    final Iterable<String> keys = parsedJson.keys;
    final Map<String, List<String>> parsedManifest =
        Map<String, List<String>>.fromIterables(
            keys,
            keys.map<List<String>>((String key) =>
                List<String>.from(parsedJson[key] as List<dynamic>)));
    return SynchronousFuture<Map<String, List<String>>>(parsedManifest);
  }

  String _chooseVariant(
      String main, ImageConfiguration config, List<String> candidates) {
    if (config.devicePixelRatio == null ||
        candidates == null ||
        candidates.isEmpty) return main;
    final SplayTreeMap<double, String> mapping = SplayTreeMap<double, String>();
    for (final String candidate in candidates)
      mapping[_parseScale(candidate)] = candidate;
    return _findNearest(mapping, config.devicePixelRatio);
  }

  String _findNearest(SplayTreeMap<double, String> candidates, double value) {
    if (candidates.containsKey(value)) return candidates[value];
    final double lower = candidates.lastKeyBefore(value);
    final double upper = candidates.firstKeyAfter(value);
    if (lower == null) return candidates[upper];
    if (upper == null) return candidates[lower];
    if (value > (lower + upper) / 2)
      return candidates[upper];
    else
      return candidates[lower];
  }

  static final RegExp _extractRatioRegExp = RegExp(r'/?(\d+(\.\d*)?)x$');

  double _parseScale(String key) {
    if (key == assetName) {
      return _naturalResolution;
    }

    final Uri assetUri = Uri.parse(key);
    String directoryPath = '';
    if (assetUri.pathSegments.length > 1) {
      directoryPath = assetUri.pathSegments[assetUri.pathSegments.length - 2];
    }

    final Match match = _extractRatioRegExp.firstMatch(directoryPath);
    if (match != null && match.groupCount > 0)
      return double.parse(match.group(1));
    return _naturalResolution; // i.e. default to 1.0x
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AssetImage &&
        other.keyName == keyName &&
        other.bundle == bundle;
  }

  @override
  int get hashCode => hashValues(keyName, bundle);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'AssetImage')}(bundle: $bundle, name: "$keyName")';
}

abstract class GifAssetBundleImageProvider extends AssetBundleImageProvider {
  @protected
  GifMultiFrameImageStreamCompleter streamCompleter;
  @protected
  int repetitionCount;
  @protected
  Duration replayDuration;
  @protected
  bool reverse;

  GifAssetBundleImageProvider(
      this.repetitionCount, this.replayDuration, this.reverse);

  @override
  ImageStreamCompleter load(AssetBundleImageKey key, DecoderCallback decode) {
    InformationCollector collector;
    assert(() {
      collector = () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<AssetBundleImageKey>('Image key', key);
      };
      return true;
    }());
    streamCompleter = GifMultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: collector,
      repetitionCount: repetitionCount,
      replayDuration: replayDuration,
      reverse: reverse,
    );
    return streamCompleter;
  }

  @protected
  Future<ui.Codec> _loadAsync(
      AssetBundleImageKey key, DecoderCallback decode) async {
    ByteData data;
    try {
      data = await key.bundle.load(key.name);
    } on FlutterError {
      PaintingBinding.instance.imageCache.evict(key);
      rethrow;
    }
    if (data == null) {
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError('Unable to read data');
    }
    return await decode(data.buffer.asUint8List());
  }
}

class GifMultiFrameImageStreamCompleter extends GifImageStreamCompleter {
  GifMultiFrameImageStreamCompleter({
    @required Future<ui.Codec> codec,
    @required double scale,
    Stream<ImageChunkEvent> chunkEvents,
    InformationCollector informationCollector,
    this.repetitionCount = -1,
    this.replayDuration,
    this.reverse = false,
  })  : assert(codec != null),
        _informationCollector = informationCollector,
        _scale = scale {
    codec.then<void>(_handleCodecReady,
        onError: (dynamic error, StackTrace stack) {
      reportError(
        context: ErrorDescription('resolving an image codec'),
        exception: error,
        stack: stack,
        informationCollector: informationCollector,
        silent: true,
      );
    });
    if (chunkEvents != null) {
      chunkEvents.listen(
        (ImageChunkEvent event) {
          if (hasListeners) {
            // Make a copy to allow for concurrent modification.
            final List<ImageChunkListener> localListeners = _listeners
                .map<ImageChunkListener>(
                    (ImageStreamListener listener) => listener.onChunk)
                .where(
                    (ImageChunkListener chunkListener) => chunkListener != null)
                .toList();
            for (final ImageChunkListener listener in localListeners) {
              listener(event);
            }
          }
        },
        onError: (dynamic error, StackTrace stack) {
          reportError(
            context: ErrorDescription('loading an image'),
            exception: error,
            stack: stack,
            informationCollector: informationCollector,
            silent: true,
          );
        },
      );
    }
  }

  ui.Codec _codec;
  final double _scale;
  final InformationCollector _informationCollector;
  ui.FrameInfo _nextFrame;
  List<ui.FrameInfo> _frames = List();

  // When the current was first shown.
  Duration _shownTimestamp;

  // The requested duration for the current frame;
  Duration _frameDuration;

  // How many frames have been emitted so far.
  int _framesEmitted = 0;
  Timer _timer;

  // Used to guard against registering multiple _handleAppFrame callbacks for the same frame.
  bool _frameCallbackScheduled = false;

  int repetitionCount;
  Duration replayDuration;
  bool reverse;

  void _handleCodecReady(ui.Codec codec) async {
    _codec = codec;
    assert(_codec != null);
    print(
        "<gifImage> repetitionCount ${_codec.repetitionCount} frameCount ${_codec.frameCount}");
    if (_codec.frameCount > 1) {
      _frames = List();
      for (int i = 0; i < _codec.frameCount; i++) {
        ui.FrameInfo frameInfo = await _codec.getNextFrame();
        _frames.add(frameInfo);
      }
    }
    if (hasListeners) {
      _decodeNextFrameAndSchedule();
    }
  }

  void _handleAppFrame(Duration timestamp) {
    _frameCallbackScheduled = false;
    if (!hasListeners) return;
    if (_isFirstFrame() || _hasFrameDurationPassed(timestamp)) {
      _emitFrame(ImageInfo(image: _nextFrame.image, scale: _scale));
      _shownTimestamp = timestamp;
      _frameDuration = _nextFrame.duration;
      _nextFrame = null;
      final int completedCycles = _framesEmitted ~/ _codec.frameCount;
      // *******Add
      // 自定义循环次数
      // 不使用_codec本身的循环次数
//      if (_codec.repetitionCount == -1 ||
//          completedCycles <= _codec.repetitionCount) {
//        _decodeNextFrameAndSchedule();
//      }
      print("<gifImage> _handleAppFrame completedCycles $completedCycles");
      if (repetitionCount == -1 || completedCycles <= repetitionCount) {
        _decodeNextFrameAndSchedule();
      } else if (replayDuration != null) {
        _timer?.cancel();
        _timer = null;
        _timer = Timer(replayDuration, () {
          _framesEmitted = 0;
          _decodeNextFrameAndSchedule();
        });
      }
      return;
    }
    print("<gifImage> _handleAppFrame _timer");
    final Duration delay = _frameDuration - (timestamp - _shownTimestamp);

    _timer = Timer(delay * timeDilation, () {
      _scheduleAppFrame();
    });
  }

  bool _isFirstFrame() {
    return _frameDuration == null;
  }

  bool _hasFrameDurationPassed(Duration timestamp) {
    assert(_shownTimestamp != null);
    return timestamp - _shownTimestamp >= _frameDuration;
  }

  Future<void> _decodeNextFrameAndSchedule() async {
    try {
      if ((_frames?.length ?? 0) > 0) {
        int frameNum = _framesEmitted % _codec.frameCount;
        if (reverse) {
          _nextFrame = _frames[_codec.frameCount - frameNum - 1];
          print("<gifImage> frameCount ${_codec.frameCount - frameNum - 1}");
        } else {
          _nextFrame = _frames[frameNum];
        }
        print("<gifImage> _decodeNextFrameAndSchedule $frameNum");
      } else {
        _nextFrame = await _codec.getNextFrame();
        print("<gifImage> _decodeNextFrameAndSchedule from _codec");
      }
    } catch (exception, stack) {
      reportError(
        context: ErrorDescription('resolving an image frame'),
        exception: exception,
        stack: stack,
        informationCollector: _informationCollector,
        silent: true,
      );
      return;
    }
    if (_codec.frameCount == 1) {
      // This is not an animated image, just return it and don't schedule more
      // frames.
      _emitFrame(ImageInfo(image: _nextFrame.image, scale: _scale));
      return;
    }
    _scheduleAppFrame();
  }

  void _scheduleAppFrame() {
    if (_frameCallbackScheduled) {
      return;
    }
    _frameCallbackScheduled = true;
    SchedulerBinding.instance.scheduleFrameCallback(_handleAppFrame);
  }

  void _emitFrame(ImageInfo imageInfo) {
    setImage(imageInfo);
    _framesEmitted += 1;
  }

  @override
  void addListener(ImageStreamListener listener) {
    if (!hasListeners && _codec != null) _decodeNextFrameAndSchedule();
    super.addListener(listener);
  }

  @override
  void removeListener(ImageStreamListener listener) {
    super.removeListener(listener);
    if (!hasListeners) {
      _timer?.cancel();
      _timer = null;
    }
  }

  clear() {
    _frames?.clear();
    _frames = null;
  }
}

abstract class GifImageStreamCompleter extends ImageStreamCompleter {
  final List<ImageStreamListener> _listeners = <ImageStreamListener>[];
}
