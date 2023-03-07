import 'package:flutter/material.dart';
import 'package:siscom_pos/utils/widget/back_button_appbar.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

class AppBarApp extends StatelessWidget implements PreferredSizeWidget {
  final title,bg,action,page;
  AppBarApp({required this.title,this.bg,this.action,this.page});
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: bg??Colors.white,
      title: TextLabel(
        text: title,
      
        size: 18.0,
      ),
      leading: BackButtonAppbar (page: page,),
      actions: action??[],
    );
  }
}
