import 'http.dart';

class WebService {
  Future<String> url(String url) async {
    try{
      var response = await HttpService().get(url);
      return response.toString();
    }
    catch(e){
      return null;
    }
  }
}