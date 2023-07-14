import 'dart:convert';

import 'package:admin_ebiblioteka/providers/base_provider.dart';
import 'package:http/http.dart';

import '../models/user.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super('Users');

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  Future<dynamic> changeEmail(int userId, String email) async {
    var url = "${BaseProvider.baseUrl}$endpoint/$userId";

    var uri = Uri.parse(url);

    List<Map<String, dynamic>> patchRequest = [
      {"op": "replace", "path": "/email", "value": email}
    ];
    var jsonRequest = jsonEncode(patchRequest);
    var headers = createHeaders();

    Response response = await patch(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = data;

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<dynamic> changePassword(dynamic object) async {
    var url = "${BaseProvider.baseUrl}$endpoint/ChangePassword";

    var uri = Uri.parse(url);
    
    var jsonRequest = jsonEncode(object);
    var headers = createHeaders();

    Response response = await put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      //var data = jsonDecode(response.body); 

      //var result = data;

      // ne može se vraćati boy od responsa ako ga nema
    } else {
      throw new Exception("Unknown error");
    }
  }
}
