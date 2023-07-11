
import 'package:admin_ebiblioteka/models/photo.dart';
import 'package:admin_ebiblioteka/providers/base_provider.dart';

class PhotoProvider extends BaseProvider<Photo> {
  PhotoProvider() : super('Photos');

  @override
  Photo fromJson(data) {
    return Photo.fromJson(data);
  }
}
