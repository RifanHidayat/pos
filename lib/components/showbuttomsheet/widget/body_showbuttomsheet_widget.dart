import 'package:flutter/material.dart';

class Body {
  static Widget body(List<Widget> widget) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: widget.map((child) => child).toList(),
              ),
            ),
          ),
        ),
      );
    });
  }
}
