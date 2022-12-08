import 'dart:convert';

import 'package:http/http.dart' as http;

class TranslationApi{
  static const _apiKey="AIzaSyBUmxT7NqTeiNa3bFfwGbfFs80R55D2JIg";

  static Future<String> translate(String message,String languageCode) async{
    final response= await http.post(Uri.parse(
        "https://translation.googleapis.com/language/translate/v2?target=$languageCode&key=$_apiKey&q=$message"
    ));

    if(response.statusCode==200){
      final body=json.decode(response.body);
      final translations=body["data"]["translations"] as List;
      final translation=translations.first;

      return const HtmlEscape().convert(translation["translatedText"]);
    }else{
      throw Exception();
    }
  }
}