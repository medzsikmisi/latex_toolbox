import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Center, Scaffold, Widget, Text;
import 'package:get/get.dart';
import 'package:hyperlink/hyperlink.dart';

class ConvPage extends GetPage {
  ConvPage({required super.name, required Widget childWidgets})
    : super(
        page: () => Scaffold(
          body: Center(child: childWidgets),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                direction: Axis.vertical,crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Made by Mihaly Csontos'),
                  HyperLink(
                    text:
                        '[Toolbox icons created by Freepik - Flaticon](https://www.flaticon.com/free-icons/toolbox)',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
