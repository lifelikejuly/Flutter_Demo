import 'package:externaltextureplugin_example/demo/flutter_image_list_demo.dart';
import 'package:externaltextureplugin_example/demo/image_list_demo.dart';
import 'package:externaltextureplugin_example/demo/texture_grid_demo.dart';
import 'package:externaltextureplugin_example/demo/texture_list_demo.dart';
import 'package:externaltextureplugin_example/demo/texture_single_external_demo.dart';
import 'package:externaltextureplugin_example/demo/texture_style_external_demo.dart';
import 'package:flutter/material.dart';

class TextureMainDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("外接纹理和Image.network比较"),
            RaisedButton(
              child: Text("外接纹理方案-列表"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TextureListDemo(),
                  ),
                );
              },
            ),
            RaisedButton(
              child: Text("Image方案-列表"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ImageListDemo(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("FlutterCacheImage方案-列表"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => FlutterImageListDemo(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("外接纹理单个图片图片测试"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TextureSingleExternalImageDemo(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("外接纹理多样式测试"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TextureStyleExternalImageDemo(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("外接纹理Grid列表"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TextureGridListDemo(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
