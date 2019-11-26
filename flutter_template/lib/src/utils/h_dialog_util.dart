import 'package:flutter/material.dart';
import 'package:flutter_template/src/widgets/h_loading_view.dart';

class HDialogUtil {
  static showAlertDialog(
    BuildContext context,
    List<Widget> actions, {
    barrierDismissible = true,
    Widget title = const Text("title"),
    Widget content = const Text("content"),
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          child: AlertDialog(
            title: title,
            content: content,
            actions: actions,
          ),
          onWillPop: () async {
            return Future.value(barrierDismissible);
          },
        );
      },
    );
  }

  static showLoadingDialog(
    BuildContext context, {
    barrierDismissible = true,
    String msg = "正在加载中...",
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          child: LoadingDialog(
            msg: msg,
          ),
          onWillPop: () async {
            return Future.value(barrierDismissible);
          },
        );
      },
    );
  }
}

