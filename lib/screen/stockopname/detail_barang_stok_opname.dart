import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/stok_opname_controller.dart';
import 'package:siscom_pos/screen/stockopname/berhasil_menambhakan_data.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbarmenu.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_column.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';


class DetailBarangStokOpname extends StatefulWidget {
  const DetailBarangStokOpname({super.key});

  @override
  State<DetailBarangStokOpname> createState() => _DetailBarangStokOpnameState();
}



class _DetailBarangStokOpnameState extends State<DetailBarangStokOpname> {

  final controller=Get.put(StockOpnameController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     controller.fetchDetailaBarang();

  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarApp(title: "Detail barang Stok  Opname"),
      body: Container(
        padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1,color: Utility.grey600),
                    ),
                     padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                    child:Align(
                        alignment: Alignment.center,
                      child: TextGroupColumn(title: "Total Stok",subtitleBold: true,subtitle: "40000",)))),
                      SizedBox(width: 10,),
                 Expanded
                 (
                  flex: 50,
                  child: Container(
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1,color: Utility.grey600),
                    ),
                      padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0,right: 0),
                        child: TextGroupColumn(title: "Total Fisik",subtitleBold: true,subtitle: "40000",)))))
              ],
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1)
              ),
               child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.scan),
                  SizedBox(width: 10,),
                  TextLabel(text: 'Scan Barcode' ,size: 14.0,weigh: FontWeight.bold, )
                ],
               ),
            ),
            SizedBox(height: 10,),
            SearchApp() ,
             SizedBox(height: 20,),
            Obx(() =>  Column(
              children: List.generate(controller.barangs.length, (index) => _list(index)),
             ))
          ],
        ),
     

      ),

    );
  }

  Widget _list (index){
    var data=controller.barangs[index];
    return InkWell(
      onTap: (){
        detailItem(index);
      },
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                
              Expanded(
                flex: 80,
                child: TextGroupColumn(
                  title: data.nama,
                  titleBold: true,
                  subtitle: data.stok.toString(),
                ),
              ),
                Expanded(
                flex: 20,
                child: Icon(Iconsax.edit_2,color: Utility.grey600,),
              )
              ],
            ),
            SizedBox(height: 10,),
            Divider(),
             SizedBox(height: 10,),
    
          ],
        ),
    
      ),
    );
  }

    void detailItem(index){
      var data=controller.barangs[index];
 
   
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
                                  TextLabel(text: data.nama,weigh: FontWeight.w700,),
                                  SizedBox(height: 5,),
                                    TextLabel(text: data.stok.toString(),color: Utility.grey900,)
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
                                       TextLabel(text: controller.gudangCtr.text,weigh: FontWeight.bold ,size: 13.0,),
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
                                       TextLabel(text:data.stok.toString(),weigh: FontWeight.bold ,size: 13.0,),
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
                                       TextLabel(text: "",weigh: FontWeight.bold ,size: 13.0,),
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

                              child: InkWell(
                                onTap: (){
                                  Get.to(BerhasilMenambahkanData());
                                },
                                child: Container(
                              
                                  decoration: BoxDecoration(
                                    color: Utility.primaryDefault,
                                    border: Border.all(width: 1,color: Utility.primaryDefault),
                                    borderRadius: BorderRadius.circular(3)
                                  ),
                                padding: EdgeInsets.only(top: 10,bottom: 10),
                                  
                                  
                                  child: Center(child: TextLabel(text: "Simpan",color: Colors.white,)),
                                ),
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