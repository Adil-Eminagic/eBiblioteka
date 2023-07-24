
import '../models/photo.dart';
import '../providers/base_provider.dart';

class PhotoProvider extends BaseProvider<Photo> {
  PhotoProvider() : super('Photos');

  @override
  Photo fromJson(data) {
    return Photo.fromJson(data);
  }
}
