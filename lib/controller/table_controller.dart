import 'package:get/get.dart';
import 'package:latex_toolbox/util/text_converter.dart';

class TableController extends GetxController {
  TextConverter? converter;

  RxBool containsHeader = RxBool(true);

  final RxString _path = RxString('No file selected');

  String get path => _path.value;

  setPath(String path) {
    _path.value = path;
    converter = TextConverter(path);
  }

  toggleHeader(index) => containsHeader.value = index != 1;

  convertAndCopy() {}
}
