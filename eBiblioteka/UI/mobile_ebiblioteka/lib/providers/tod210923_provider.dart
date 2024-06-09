
import '../models/todo210923.dart';
import '../providers/base_provider.dart';

class ToDo210923Provider extends BaseProvider<ToDo210923> {
  ToDo210923Provider() : super('ToDo210923s');
  @override
  ToDo210923 fromJson(data) {
    return ToDo210923.fromJson(data);
  }
}
