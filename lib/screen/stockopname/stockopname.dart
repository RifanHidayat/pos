import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/screen/penjualan/dashboard_penjualan.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/screen/stockopname/detail_stock_opname.dart';
import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbarmenu.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class StockOpname extends StatelessWidget {
  const StockOpname({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBarApp(
        page: DashboardPenjualan(),
        title: "Stok opname",action: [
        IconButton(onPressed: (){
          
          Get.to(TambahStokOpname());
        }, icon: Icon(Iconsax.add_square,color: Utility.grey600,))
      ],),
      body: Container(
        padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
     
        child: Column(
          children: [
            SearchApp(),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    child: Column(
                      children: List.generate(10, (index) {
                        return _list();
                      }),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
    
  }
  Widget _list(){
    return InkWell(
      onTap: (){
        Get.to(DetailStokOpname());
      //  detailItem();
      },
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          child: Column(
            children: [
              Row(
              
                children: [
                    Expanded(
                      flex: 50,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [ 
                            TextLabel(text: "No. Faktur",weigh: FontWeight.w700,size: 14.0,),
                            SizedBox(height: 5,),
                            TextLabel(text: "001-Nama Cabang",color: Utility.grey600,),
                              TextLabel(text: "001-Nama Gudang",color: Utility.grey600)
                    
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextLabel(text: "7 maret 2022",color: Utility.grey600),
                          SizedBox(width: 5,)
    ,                    Icon(Icons.arrow_forward_ios,size: 20,color: Utility.grey600)
                        ],
                      ),
                    ))
                ],
              ),
              SizedBox(height: 10,),
              Divider()
            ],
          ),
        ),
      ),
    );
  }

  void detailItem(){

    showModalBottomSheet<String>(
        context: Get.context!,
   
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(6.0),
          ),
        ),
        builder: (context) {
       
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
                  child: Container(
                    child: Column(
              
                          mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                        
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextLabel(text: "Apple iphone 13 pro max 128GB",weigh: FontWeight.w700,),
                                  SizedBox(height: 5,),
                                    TextLabel(text: "002- Gudang bahan baku",color: Utility.grey900,)
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: InkWell(
                                onTap: ()=>Get.back(),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.close,color: Utility.grey900)),
                              ))
                          ],
                        ),
                        SizedBox(height: 10,),

                        
                        Row(
                          children: [
                            Expanded(
                              flex: 50,
                              child: Container(
                                padding: EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1,color: Utility.grey100)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabel(text: "Gudang",),
                                    SizedBox(height: 10,),
                                       TextLabel(text: "Nama Gudang",weigh: FontWeight.bold ,size: 13.0,),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                               Expanded(
                              flex: 50,
                              child: Container(
                                padding: EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1,color: Utility.grey100)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabel(text: "Stock",),
                                    SizedBox(height: 10,),
                                       TextLabel(text: "100000",weigh: FontWeight.bold ,size: 13.0,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                         
                        Row(
                          children: [
                            Expanded(
                              flex: 50,
                              child: Container(
                                padding: EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1,color: Utility.grey100)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabel(text: "Fisik",),
                                    SizedBox(height: 10,),
                                       TextLabel(text: "Nama Gudang",weigh: FontWeight.bold ,size: 13.0,),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                               Expanded(
                              flex: 50,
                              child: Container(
                                padding: EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1,color: Utility.grey100)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabel(text: "Selisih",),
                                    SizedBox(height: 10,),
                                       TextLabel(text: "100000",weigh: FontWeight.bold ,size: 13.0,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),

                        Row(
                          children: [
                            Expanded(
                              flex: 50,

                              child: Container(

                                decoration: BoxDecoration(
                                  border: Border.all(width: 1,color: Utility.primaryDefault),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                                
                                
                                child: Center(child: TextLabel(text: "Hapus",color: Utility.primaryDefault,)),
                              ),
                            ),
                            SizedBox(width: 5,),
                               Expanded(
                              flex: 50,

                              child: Container(

                                decoration: BoxDecoration(
                                  color: Utility.primaryDefault,
                                  border: Border.all(width: 1,color: Utility.primaryDefault),
                                  borderRadius: BorderRadius.circular(3)
                                ),
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                                
                                
                                child: Center(child: TextLabel(text: "Simpan",color: Colors.white,)),
                              ),
                            )
                          ],
                        ),
                          SizedBox(height: 10,),
                        
                      ],
                    ),
                  ),
                ),
                        ));
          });
        });
  
   }
}