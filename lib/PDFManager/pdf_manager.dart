import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;
class PdfManager{

  static Future<String> loadPdf(String url,String type) async{

    var response=await http.get(Uri.parse(url));
    var dir=await path_provider.getTemporaryDirectory();

    String name= type=="pdf"? "${dir.path}/data.pdf":"${dir.path}/data.docx";

    File file=File(name);
    await file.writeAsBytes(response.bodyBytes,flush: true);
    return file.path;
  }

}