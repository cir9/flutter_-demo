import '../model/course.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

Future<File> get localFile async {
  final directory =  await getApplicationDocumentsDirectory();
  print('get filepath ${directory.path}/data.json');
  return File('${directory.path}/data.json');
}

Future<File> saveData() async {
  final file = await localFile;
  String jstr = json.encode(term.toJson());
  print('data saving');
  return file.writeAsString(jstr);
}

Future<void> loadData() async {
  try {
    final file = await localFile;
    String jstr = await file.readAsString();
    var jobj = json.decode(jstr);
    term = Term.fromJson(jobj);
  } catch (e) {
    print(e);
    term = Term();
  }
}

Future<String> testLoadData() async {
  try {
    final file = await localFile;
    return file.readAsString();
  } catch (e) {
    return e.toString();
  }
}




var term = Term(
  courses: [],
  classSpans: ClassSpans([])
);






