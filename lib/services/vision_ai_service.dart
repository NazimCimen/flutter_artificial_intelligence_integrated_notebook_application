import 'package:dio/dio.dart';

class VisionAiService {
  String? text;
  final String projectId = 'my-demo-app-413816';
  Future<String?> annotateImages(String? imageUrl) async {
    const String accessToken =
        'apikey';
    const String baseUrl = 'https://vision.googleapis.com/v1/images:annotate';
    var dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    dio.options.headers['x-goog-user-project'] = projectId;
    dio.options.headers[Headers.contentTypeHeader] =
        'application/json; charset=utf-8';

    try {
      var response = await dio.post(
        baseUrl,
        data: {
          "requests": [
            {
              "features": [
                {"type": "DOCUMENT_TEXT_DETECTION"}
              ],
              "image": {
                "source": {"imageUri": imageUrl}
              }
            }
          ]
        },
      );
      print(response.data);
      if (response.statusCode == 200) {
        var responseData = response.data;
        text =
            response.data['responses'][0]['textAnnotations'][0]['description'];
        if (text != null) {
          return text;
        }
      }
    } catch (error) {
      //hata kontrolü
    }
  }
}
