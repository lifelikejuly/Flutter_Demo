import 'dart:math';

import 'package:flutter/material.dart';

class GestureScaleDemo1 extends StatefulWidget {
  @override
  _GestureScaleDemoState createState() => _GestureScaleDemoState();
}

class _GestureScaleDemoState extends State<GestureScaleDemo1> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;

  Offset _normalizedOffset;
  Offset _moveTempOffset = Offset.zero;
  Image _image;

  // 最大缩放值
  double _maxScale = 3.0;

  // 最小缩放值
  double _minScale = 1.0;

  double _originScaleValue = 1.0;

  //原始图片大小矩阵
  Rect _rect;

  Size _screenSize = Size.zero;
  Size _imageSize = Size.zero;

  double _multipleX = 1;
  double _multipleY = 1;
  double _maxSize;

  double _double2(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  _onHandleScaleEnd(ScaleEndDetails details) {
//    print("GestureScaleDemo _OnHandleScaleEnd \n ${details.toString()}");
  }

  _onHandleScaleStart(ScaleStartDetails details) {
    print("GestureScaleDemo _OnHandleScaleStart \n ${details.toString()}");
    // 触摸点和位置的偏移量 用于在更新偏移量时减去初始值
    _normalizedOffset = (details.focalPoint - _offset);
//    print("GestureScaleDemo _normalizedOffset \n ${details.toString()}");
  }

  _onHandleScaleUpdate(ScaleUpdateDetails details) {
    print("GestureScaleDemo _OnHandleScaleUpdate \n ${details.toString()}");
    //判断位移操作或是缩放操作

    if (details.rotation == 0.0 && details.scale == 1.0) {
    } else {
      //缩放操作
      double _tempScale = _double2(_scale + (details.scale - 1));

      if (_tempScale >= _minScale && _tempScale <= _maxScale) {
        _scale = _tempScale;
      } else {
        if (_tempScale <= _minScale) {
          _scale = _minScale;
        } else if (_tempScale >= _maxScale) {
          _scale = _maxScale;
        }
      }
    }
    //位移操作
    double _moreScale = (_scale - _originScaleValue);

    Offset _tempOffset = (details.focalPoint - _normalizedOffset);
//    Offset _moveOffset = (_tempOffset - _moveTempOffset);
    double _moveDx = _tempOffset.dx.abs();
    double _moveDy = _tempOffset.dy.abs();

    print(
        "GestureScaleDemo _moveOffset _moreScale $_moreScale _moveDx $_moveDx width  ${25 * _moreScale}");
//      print(
//          "GestureScaleDemo _moveOffset _tempOffset ${_tempOffset.toString()}");


    if (_moveDy <= 25 * _moreScale && _moveDx <= 25 * _moreScale) {
      // 减去初始值偏移量 获取真实偏移值
      _offset = _tempOffset;
    } else {
      if (_moveDy > 25 * _moreScale) {
        _moveDy = 25 * _moreScale;
        if (_tempOffset.dy > 0) {
          _tempOffset = Offset(_tempOffset.dx, _moveDy);
        } else {
          _tempOffset = Offset(_tempOffset.dx, -_moveDy);
        }
      }

      if (_moveDx > 25 * _moreScale) {
        _moveDx = 25 * _moreScale;
        if (_tempOffset.dx > 0) {
          _tempOffset = Offset(_moveDx, _tempOffset.dy);
        } else {
          _tempOffset = Offset(-_moveDx, _tempOffset.dy);
        }
      }
      _offset = _tempOffset;
    }
//    _rect = Offset(_screenSize.width / 2 + _offset.dx,
//            _screenSize.height / 2 + _offset.dy) &
//        Size(_rect.width * _moreScale, _rect.height * _moreScale);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _image = Image.asset("res/img/jay.jpg");
  }

  /// 计算位移范围
  _calMoveSize() {
    _rect = Rect.fromCenter(
      center: Offset(_screenSize.width / 2, _screenSize.height / 2),
      width: _imageSize.width * _scale,
      height: _imageSize.height * _scale,
    );

    _multipleX = 50 / _imageSize.width * _scale;
    _multipleY = 50 / _imageSize.height * _scale;
  }

  /// 初始化计算图片的大小 主要在做缩放和移动时控制最大和最小的缩放和移动范围
  ///
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 先获取图片大小
    ImageProvider image = AssetImage("res/img/jay.jpg");
    ImageStream imageStream =
        image.resolve(createLocalImageConfiguration(context));
    ImageStreamListener imageListener =
        ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        print("GestureScaleDemo imageInfo ${imageInfo.image.toString()}");
        int imageWidth = imageInfo.image.width;
        int imageHeight = imageInfo.image.height;
        _imageSize = Size(imageWidth.toDouble(), imageHeight.toDouble());
        // 获取屏幕大小
        _screenSize = MediaQuery.of(context).size;
        double screenWidth = _screenSize.width;
        double screenHeight = _screenSize.height;
        if (screenWidth > screenHeight) {
          _maxSize = screenHeight;
        } else {
          _maxSize = screenWidth;
        }
        // 屏幕大小和图片大小做比较
        double scaleHeight = screenHeight / imageHeight;
        double scaleWidth = screenWidth / imageWidth;
        _minScale = _double2(min(scaleHeight, scaleWidth));
        _scale = _minScale;
        _maxScale = _minScale + 2;
        _originScaleValue = _scale - 1;
        _moveTempOffset = _offset;
        //算出初始缩放值以及最大和最小 和 移动边界
        _calMoveSize();
        setState(() {});
      });
    });
    imageStream.addListener(imageListener);
  }

  @override
  Widget build(BuildContext context) {
    print("GestureScaleDemo _offset ${_offset.toString()} _scale $_scale");
    return Scaffold(
      body: GestureDetector(
        onScaleEnd: _onHandleScaleEnd,
        onScaleUpdate: _onHandleScaleUpdate,
        onScaleStart: _onHandleScaleStart,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(_offset.dx, _offset.dy)
                    ..scale(_scale),
                  child: _image,
                  origin: Offset(_screenSize.width / 2, _screenSize.height / 2),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: CircleCropPainter(),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: ReactPainter(_rect),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircleCropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double maxSize;
    if (width > height) {
      maxSize = height;
    } else {
      maxSize = width;
    }

    Paint paint = Paint();
    paint.color = Color(0x71000000);
    paint.isAntiAlias = true;
    canvas.drawDRRect(
        RRect.fromLTRBR(0.0, 0.0, width, height, Radius.zero),
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(width / 2, height / 2),
            width: maxSize - 50,
            height: maxSize - 50,
          ),
          Radius.circular(maxSize / 2),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ReactPainter extends CustomPainter {
  Rect rect;

  ReactPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(rect, Paint()..color = Colors.black12);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
