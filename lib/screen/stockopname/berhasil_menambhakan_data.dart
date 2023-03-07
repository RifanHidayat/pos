import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

class BerhasilMenambahkanData extends StatelessWidget {
  const BerhasilMenambahkanData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
              height: MediaQuery.of(context).size.height,
               width: MediaQuery.of(context).size.width,
          child: Column(
           
            children: [
            Expanded(
              child: Container(
                height: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                     crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Image.asset("assets/berhasil_menambahkan_data.png"),
                        SizedBox(height: 10,),
                   TextLabel(text: "Stok Opname Berhasil disimpan",weigh: FontWeight.bold,size: 16.0,color: Utility.grey900,)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color:Utility.primaryDefault,
                  borderRadius: BorderRadius.circular(5),
                  
                ),
                padding: EdgeInsets.only(top: 20,bottom: 20),
                child: Center(child: TextLabel(text: 'Ok,kembali ke menu stok opname',color: Colors.white,size: 14.0,)),),
            ),
              SizedBox(height: 10,)

            
            ],
          ),
        ),
      ),
    );
  }
}