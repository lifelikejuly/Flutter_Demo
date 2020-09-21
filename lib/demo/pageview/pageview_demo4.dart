import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ExampleCustom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ExampleCustomState();
  }
}

class _ExampleCustomState extends State<ExampleCustom> {
  //properties want to custom
  int _itemCount;

  bool _loop;

  bool _autoplay;

  int _autoplayDely;

  double _padding;

  bool _outer;

  double _radius;

  double _viewportFraction;

  SwiperLayout _layout;

  int _currentIndex;

  double _scale;

  Axis _scrollDirection;

  Curve _curve;

  double _fade;

  bool _autoplayDisableOnInteraction;

  CustomLayoutOption customLayoutOption;

  Widget _buildItem(BuildContext context, int index) {
    return ClipRRect(
      borderRadius: new BorderRadius.all(new Radius.circular(_radius)),
      child: new Image.asset(
        images[index % images.length],
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  void didUpdateWidget(ExampleCustom oldWidget) {
//    customLayoutOption = new CustomLayoutOption(startIndex: -1, stateCount: 3)
//        .addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate([
//      new Offset(-370.0, -40.0),
//      new Offset(0.0, 0.0),
//      new Offset(370.0, -40.0)
//    ]);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    customLayoutOption = new CustomLayoutOption(startIndex: -1, stateCount: 3)
//        .addRotate([-25.0 / 180, 0.0, 25.0 / 180])
        .addTranslate([
//      new Offset(-350.0, 0.0),
//      new Offset(0.0, 0.0),
//      new Offset(350.0, 0.0)
    ]);
    _fade = 1.0;
    _currentIndex = 0;
    _curve = Curves.ease;
    _scale = 0.5;
    _controller = new SwiperController();
    _layout = SwiperLayout.TINDER;
    _radius = 10.0;
    _loop = true;
    _itemCount = 3;
    _autoplay = false;
    _autoplayDely = 3000;
    _viewportFraction = 0.4;
    _outer = true;
    _scrollDirection = Axis.horizontal;
    _autoplayDisableOnInteraction = false;
    super.initState();
  }

// maintain the index

  Widget buildSwiper() {
    return new Swiper(
      layout: SwiperLayout.CUSTOM,
      customLayoutOption: new CustomLayoutOption(
          startIndex: -1,
          stateCount: 3
      ).addTranslate([
        new Offset(-370.0, -40.0),
        new Offset(-50, 0.0),
        new Offset(370.0, -40.0)
      ]),
      itemWidth: 300.0,
      itemHeight: 200.0,
      itemBuilder: (context, index) {
        return new Container(
          color: Colors.grey,
          child: new Center(
            child: new Text("$index"),
          ),
        );
      },
      itemCount: 20,
      viewportFraction: 0.4,
    );
  }

  SwiperController _controller;
  TextEditingController numberController = new TextEditingController();

  double itemSize = 100;
  @override
  Widget build(BuildContext context) {
    itemSize = MediaQuery.of(context).size.width / 2;
    return new Column(children: <Widget>[
      new Container(
        color: Colors.black87,
        child: new SizedBox(
            height: 300.0, width: double.infinity, child: buildSwiper()),
      ),
    ]);
  }
}

const List<String> images = [
  "images/bg0.jpeg",
  "images/bg1.jpeg",
  "images/bg2.jpeg",
];

class FormWidget extends StatelessWidget {
  final String label;

  final Widget child;

  FormWidget({this.label, this.child});

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: new EdgeInsets.all(5.0),
        child: new Row(
          children: <Widget>[
            new Text(label, style: new TextStyle(fontSize: 14.0)),
            new Expanded(
                child:
                new Align(alignment: Alignment.centerRight, child: child))
          ],
        ));
  }
}

class NumberPad extends StatelessWidget {
  final num number;
  final num step;
  final num max;
  final num min;
  final ValueChanged<num> onChangeValue;

  NumberPad({this.number, this.step, this.onChangeValue, this.max, this.min});

  void onAdd() {
    onChangeValue(number + step > max ? max : number + step);
  }

  void onSub() {
    onChangeValue(number - step < min ? min : number - step);
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new IconButton(icon: new Icon(Icons.exposure_neg_1), onPressed: onSub),
        new Text(
          number is int ? number.toString() : number.toStringAsFixed(1),
          style: new TextStyle(fontSize: 14.0),
        ),
        new IconButton(icon: new Icon(Icons.exposure_plus_1), onPressed: onAdd)
      ],
    );
  }
}

class FormSelect<T> extends StatefulWidget {
  final String placeholder;
  final ValueChanged<T> valueChanged;
  final List<dynamic> values;
  final dynamic value;

  FormSelect({this.placeholder, this.valueChanged, this.value, this.values});

  @override
  State<StatefulWidget> createState() {
    return _FormSelectState();
  }
}

class _FormSelectState extends State<FormSelect> {
  int _selectedIndex = 0;

  @override
  void initState() {
    for (int i = 0, c = widget.values.length; i < c; ++i) {
      if (widget.values[i] == widget.value) {
        _selectedIndex = i;
        break;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String placeholder = widget.placeholder;
    List<dynamic> values = widget.values;

    return new Container(
      child: new InkWell(
        child: new Text(_selectedIndex < 0
            ? placeholder
            : values[_selectedIndex].toString()),
        onTap: () {
          _selectedIndex = 0;
          showBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return new SizedBox(
                  height: values.length * 30.0 + 200.0,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new SizedBox(
                        height: values.length * 30.0 + 70.0,
                        child: CupertinoPicker(
                          itemExtent: 30.0,
                          children: values.map((dynamic value) {
                            return new Text(value.toString());
                          }).toList(),
                          onSelectedItemChanged: (int index) {
                            _selectedIndex = index;
                          },
                        ),
                      ),
                      new Center(
                        child: new RaisedButton(
                          onPressed: () {
                            if (_selectedIndex >= 0) {
                              widget
                                  .valueChanged(widget.values[_selectedIndex]);
                            }

                            setState(() {});

                            Navigator.of(context).pop();
                          },
                          child: new Text("ok"),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
