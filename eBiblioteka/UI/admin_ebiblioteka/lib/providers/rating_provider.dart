
import '../models/rating.dart';
import '../providers/base_provider.dart';

class RatingProvider extends BaseProvider<Rating> {
  RatingProvider() : super('Ratings');

  @override
  Rating fromJson(data) {
    return Rating.fromJson(data);
  }
}
