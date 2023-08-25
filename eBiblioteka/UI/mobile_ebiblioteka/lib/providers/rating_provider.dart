import 'package:http/http.dart';

import '../models/rating.dart';
import '../providers/base_provider.dart';

class RatingProvider extends BaseProvider<Rating> {
  RatingProvider() : super('Ratings');

  double review = 0; //to refresh after adding rate

  @override
  Rating fromJson(data) {
    return Rating.fromJson(data);
  }



  Future<double> getAverageBookRate(int bookId) async {
    var url = "${BaseProvider.baseUrl}$endpoint/BookAverageRate/$bookId";

    var uri = Uri.parse(url);

    var headers = createHeaders();

    Response response = await get(
      uri,
      headers: headers,
    );

    review = double.parse(response.body);
    notifyListeners();
    return double.parse(response.body);
  }
}
