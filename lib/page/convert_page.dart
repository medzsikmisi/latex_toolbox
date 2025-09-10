import 'package:latex_toolbox/model/conv_page.dart';
import 'package:latex_toolbox/widget/convert.dart';

class ConvertPage extends ConvPage {
  ConvertPage() : super(name: '/csvToLatex', childWidgets: Convert());
}
