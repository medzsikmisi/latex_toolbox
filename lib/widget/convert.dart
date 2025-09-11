import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ClipboardData, Clipboard;
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../controller/table_controller.dart' show TableController;

class Convert extends StatelessWidget {
  const Convert({super.key});

  @override
  StatelessElement createElement() {
    Get.put<TableController>(TableController());
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    final TableController c = Get.find<TableController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowedExtensions: ['csv'],
                allowMultiple: false,
              );
              if (result == null) return;
              final file = result.files.single;
              if (file.extension != 'csv') {
                Get.snackbar('Error', 'Use only CSV files');
                return;
              }
              c.setPath(file.path!);
            },
            child: Text('Select file'),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Text(c.path)),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Contains header'),
            ),
            ToggleSwitch(
              fontSize: 12.0,
              minHeight: 25,
              minWidth: 60.0,
              cornerRadius: 20.0,
              activeBgColors: [
                [Colors.green[800]!],
                [Colors.red[800]!],
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              initialLabelIndex: 0,
              totalSwitches: 2,
              labels: ['True', 'False'],
              radiusStyle: true,
              onToggle: (index) {
                c.toggleHeader(index);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              if (c.converter == null) {
                Get.snackbar('Warning', 'Select a file to convert');
                return;
              }
              final converter = c.converter!;
              await converter.convert();
              converter.replaceSpecialChars();
              Get.log('Converter content: ${converter.content}');
              Clipboard.setData(
                ClipboardData(
                  text: converter.getTable(
                    containsHeader: c.containsHeader.value,
                  ),
                ),
              );
              Get.snackbar(
                'Done',
                'The file has been converted and put into your clipboard.',
                duration: Duration(seconds: 2),
              );
            },
            child: Text('Convert and copy'),
          ),
        ),
      ],
    );
  }
}
