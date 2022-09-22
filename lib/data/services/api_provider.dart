import 'package:dio/dio.dart';
import 'package:working_with_location/data/services/api_client.dart';
import 'package:working_with_location/models/geocoding/geocoding.dart';

class ApiProvider {
  final ApiClient apiClient;

  ApiProvider({required this.apiClient});

  Future<String> getLocationName(String geoCodeText) async {
    late Response response;
    Map<String, String> qParams = {
      'apikey': 'your Api key',
      'geocode': geoCodeText,
      'lang': 'uz_UZ',
      'format': 'json',
      'kind': 'house',
      'rspn': '1',
      'results': '1',
    };
    response = await apiClient.dio
        .get(apiClient.dio.options.baseUrl, queryParameters: qParams);

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      Geocoding geocoding = Geocoding.fromJson(response.data);
      var text = '';
      if (geocoding.response.geoObjectCollection.featureMember.isNotEmpty) {
        text = geocoding.response.geoObjectCollection.featureMember[0].geoObject
            .metaDataProperty.geocoderMetaData.text;
      } else {
        text = 'kkkkkkkkkkkkkkkkkkkkkkk Aniqlanmagan hudud!';
      }
      return text;
    } else {
      throw Exception();
    }
  }
}
