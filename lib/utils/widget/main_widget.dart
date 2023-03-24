import 'package:flutter/material.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class MainScaffold extends StatelessWidget {
  final Color? colorSafeArea;
  final Color? colorBackground;
  final bool? returnOnWillpop;
  final String? type;
  final String? appbarTitle;
  final Widget? content;
  final Widget? contentBottom;
  final Function()? backFunction;
  final Function()? ontapAppbar;

  const MainScaffold({
    Key? key,
    required this.type,
    required this.content,
    this.colorSafeArea,
    this.colorBackground,
    this.returnOnWillpop,
    this.backFunction,
    this.appbarTitle,
    this.ontapAppbar,
    this.contentBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == "default"
        ? Container(
            color: colorSafeArea ?? Utility.baseColor2,
            child: SafeArea(
              child: Scaffold(
                  backgroundColor: colorBackground ?? Utility.baseColor2,
                  body: WillPopScope(
                    onWillPop: () async {
                      if (backFunction != null) backFunction!();
                      return returnOnWillpop ?? false;
                    },
                    child: content!,
                  )),
            ),
          )
        : type == "appbar"
            ? Container(
                color: colorSafeArea ?? Utility.baseColor2,
                child: SafeArea(
                  child: Scaffold(
                      backgroundColor: colorBackground ?? Utility.baseColor2,
                      appBar: AppBar(
                          backgroundColor: Utility.baseColor2,
                          automaticallyImplyLeading: false,
                          elevation: 2,
                          flexibleSpace: AppbarMenu1(
                            title: appbarTitle ?? "",
                            icon: returnOnWillpop == false ? 4 : 1,
                            colorTitle: Colors.black,
                            onTap: () {
                              if (ontapAppbar != null) ontapAppbar!();
                            },
                          )),
                      body: WillPopScope(
                        onWillPop: () async {
                          if (backFunction != null) backFunction!();
                          return returnOnWillpop ?? false;
                        },
                        child: content!,
                      )),
                ),
              )
            : type == "appbar_with_bottom"
                ? Container(
                    color: colorSafeArea ?? Utility.baseColor2,
                    child: SafeArea(
                      child: Scaffold(
                          backgroundColor:
                              colorBackground ?? Utility.baseColor2,
                          appBar: AppBar(
                              backgroundColor: Utility.baseColor2,
                              automaticallyImplyLeading: false,
                              elevation: 2,
                              flexibleSpace: AppbarMenu1(
                                title: appbarTitle ?? "",
                                icon: returnOnWillpop == false ? 4 : 1,
                                colorTitle: Colors.black,
                                onTap: () {
                                  if (ontapAppbar != null) ontapAppbar!();
                                },
                              )),
                          body: WillPopScope(
                            onWillPop: () async {
                              if (backFunction != null) backFunction!();
                              return returnOnWillpop ?? false;
                            },
                            child: content!,
                          ),
                          bottomNavigationBar: Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 12),
                            child: SizedBox(height: 50, child: contentBottom),
                          )),
                    ),
                  )
                : SizedBox();
  }
}
