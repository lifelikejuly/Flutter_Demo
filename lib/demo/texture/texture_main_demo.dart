import 'package:flutter/material.dart';
import 'package:flutter_demo/demo/texture/flutter_image_demo.dart';
import 'package:flutter_demo/demo/texture/texture_list_demo.dart';


class TextureMainDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("外接纹理和Image.asset比较"),
          RaisedButton(
            child: Text("外接纹理方案"),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => TextureListDemo(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("FlutterImage方案"),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => FlutterImageDemo(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
