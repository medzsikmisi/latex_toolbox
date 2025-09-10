import 'dart:io';

import 'package:csv/csv.dart' show CsvToListConverter;
import 'package:latex_toolbox/model/custom_exceptions.dart';

class TextConverter {
  String filePath;
  List<List<String>> content = List.empty();
  int columnCount = 0;
  bool containsHeader = true;

  TextConverter(this.filePath);

  convert() async {
    File file = File(filePath);
    bool fileExists = await file.exists();
    if (!fileExists) {
      throw CustomExceptions.fileNotExists();
    }
    String contentRaw = await file.readAsString();
    String delimiter = detectCsvDelimiter(contentRaw);
    content = CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(shouldParseNumbers: false, contentRaw, fieldDelimiter: delimiter);
    columnCount = content.first.length;
  }

  String detectCsvDelimiter(String csvSample) {
    final delimiters = [',', ';', '\t', '|'];
    int maxCount = 0;
    String probableDelimiter = ',';

    for (var delimiter in delimiters) {
      // Split first line using delimiter, assuming no quoted fields
      var count = csvSample.split('\n').first.split(delimiter).length;
      if (count > maxCount) {
        maxCount = count;
        probableDelimiter = delimiter;
      }
    }

    return probableDelimiter;
  }

  void replaceSpecialChars() {
    final pattern = RegExp(r'([#$%&_{}])');

    var safeContent = content.map(
      (r) => r
          .map(
            (e) => e.replaceAllMapped(
              pattern,
              (match) => ('\\${match.group(1)!}')
                  .replaceAll('\\', '\\textbackslash ')
                  .replaceAll('~', '\\~')
                  .replaceAll('^', '\\^'),
            ),
          )
          .toList(),
    );
    content = safeContent.toList();
  }

  String getTable({final bool containsHeader = false}) {
    String? header;
    if (containsHeader) {
      header = _createHeader(content.removeAt(0));
    }

    String columnFormatting =
        '|${List.generate(columnCount, (_) => 'X').join('|')}|';
    String contentAsLatex = _joinAsLatex();
    if (header != null) {
      contentAsLatex = header + contentAsLatex;
    }
    return """
\\begin{tabularx}{\\linewidth}{$columnFormatting}
\\hline
  $contentAsLatex
\\end{tabularx}
    """;
  }

  String _createHeader(List<String> firstRow) {
    return '${firstRow.map((e) => '\\textbf{$e}').join(' & ')} \\\\ \\hline \n  ';
  }

  String _joinAsLatex() {
    return content.map((e) => e.join(' & ')).join(' \\\\ \\hline \n  ');
  }
}
