import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utility.dart';

class Header {
  static form() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Quantity'),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                      height: 25,
                      width: 30,
                      padding: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Utility.primaryDefault, width: 1)),
                      child: Icon(
                        Iconsax.minus,
                        color: Utility.primaryDefault,
                      )),
                ),
                Text('1'),
                InkWell(
                  onTap: () {},
                  child: Container(
                      height: 25,
                      width: 30,
                      padding: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Utility.primaryDefault, width: 1)),
                      child: Icon(
                        Iconsax.add,
                        color: Utility.primaryDefault,
                        size: 20,
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
