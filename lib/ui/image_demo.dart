import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageDemo extends StatefulWidget {
  @override
  _ImageDemoState createState() => _ImageDemoState();
}

class _ImageDemoState extends State<ImageDemo> {
  final String networkPic =
      "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2502384351,886196727&fm=26&gp=0.jpg";
  final String netPic =
      "https:\/\/i.pximg.net\/c\/480x960\/img-master\/img\/2020\/04\/11\/00\/00\/27\/80699361_p0_master1200.jpg";
  final List<int> datas = [11, 22, 33, 44, 55, 44, 11, 233, 34, 22, 43];

  Uint8List data;
  Uint8List data2;
  Timer timer;
  int offerIndex = 0;
  StreamController<Uint8List> stream = new StreamController<Uint8List>();

  @override
  void initState() {
    super.initState();
    loadData();
//    loadData2();
  }

  void loadData() async {
    ByteBuffer byteBuffer = (await rootBundle.load('res/img/jay.jpg')).buffer;
    data = byteBuffer.asUint8List(0, byteBuffer.lengthInBytes -1);
    data[byteBuffer.lengthInBytes ~/ 2 ] = 0;
    data[byteBuffer.lengthInBytes ~/ 2 -1] = 0;
    data[byteBuffer.lengthInBytes ~/ 2 -2] = 0;
    data[byteBuffer.lengthInBytes ~/ 2 -3] = 0;
    setState(() {});
  }

  void loadData2() async {
    ByteBuffer byteBuffer = (await rootBundle.load('res/img/jay.jpg')).buffer;

    Timer.periodic(Duration(seconds: 1), (timer) {
      print("Timer Duration");
      offerIndex += byteBuffer.lengthInBytes ~/ 10;
      if (offerIndex > byteBuffer.lengthInBytes) {
        offerIndex = byteBuffer.lengthInBytes;
        timer.cancel();
      }
      data2 = byteBuffer.asUint8List(0, offerIndex);
      stream.add(data2);
      setState(() {});
    });
  }

  Widget _ImageWrapper() {
    if (data == null) {
      return CircularProgressIndicator();
    }

    return Image.memory(data);
  }

  Widget _ImageWrapper2() {
    if (data2 == null) {
      return CircularProgressIndicator();
    }

    return Image.memory(data2);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            Image.asset("res/img/jay.jpg"),
//            Image.asset("res/img/ic_run.gif"),
//            Image.network(networkPic),
//            AspectRatio(
//              aspectRatio: size.width / size.height,
//              child: Image.network(networkPic),
//            ),
//            Image.network(
//              networkPic,
//              width: 100,
//              height: 100,
//            ),
//            Image.network(
//              networkPic,
//              width: 100,
//              height: 200,
//            ),
//            Image.network(
//              networkPic,
//              fit: BoxFit.fill,
//            ),
//            Image.network(
//              networkPic,
//              fit: BoxFit.fill,
//              width: 100,
//              height: 200,
//            ),
//            Image.network(
//              networkPic,
//              fit: BoxFit.cover,
//            ),
//            Image.network(
//              networkPic,
//              fit: BoxFit.cover,
//              width: 100,
//              height: 200,
//            ),
//
//            Container(
//              height: 50,
//              width: 100,
//              child: Image.network(
//                networkPic,
//                fit: BoxFit.cover,
//              ),
//            ),

//            Image.network(netPic),
            _ImageWrapper(),
//            _ImageWrapper2(),
//            StreamBuilder(
//                stream: stream.stream,
//                builder:
//                    (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
//                  return Image.memory(snapshot.data);
//                }),
//            SizeImage(
//              imageProvider: NetworkImage(networkPic),
//            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    /// 退出时清除图片缓存
    PaintingBinding.instance.imageCache.clear();
  }
}

class SizeImage extends StatefulWidget {
  final ImageProvider imageProvider;

  const SizeImage({
    Key key,
    @required this.imageProvider,
  })  : assert(imageProvider != null),
        super(key: key);

  @override
  _SizeImageState createState() => _SizeImageState();
}

class _SizeImageState extends State<SizeImage> {
  ImageStream _imageStream;
  ImageInfo _imageInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We call _getImage here because createLocalImageConfiguration() needs to
    // be called again if the dependencies changed, in case the changes relate
    // to the DefaultAssetBundle, MediaQuery, etc, which that method uses.
    _getImage();
  }

  @override
  void didUpdateWidget(SizeImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != oldWidget.imageProvider) _getImage();
  }

  void _getImage() {
    final ImageStream oldImageStream = _imageStream;
    _imageStream =
        widget.imageProvider.resolve(createLocalImageConfiguration(context));
    if (_imageStream.key != oldImageStream?.key) {
      // If the keys are the same, then we got the same image back, and so we don't
      // need to update the listeners. If the key changed, though, we must make sure
      // to switch our listeners to the new image stream.
      final ImageStreamListener listener = ImageStreamListener(_updateImage);
      oldImageStream?.removeListener(listener);
      _imageStream.addListener(listener);
    }
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    print("ImageInfo   ${imageInfo.toString()}");
    setState(() {
      // Trigger a build whenever the image changes.
      _imageInfo = imageInfo;
    });
  }

  @override
  void dispose() {
    _imageStream.removeListener(ImageStreamListener(_updateImage));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawImage(
      image: _imageInfo?.image, // this is a dart:ui Image object
    );
  }
}
