

import 'package:http/http.dart';

import '../models/notification.dart';
import '../providers/base_provider.dart';


class NotificationProvider extends BaseProvider<Notif> {
  String? _mainBaseUrl;
  final String _mainEndpoint = "api/Notification/SendNotification";

  NotificationProvider() : super('Notifications'){
    _mainBaseUrl = const String.fromEnvironment("mainBaseUrl", defaultValue: "https://localhost:7005/");
  }

  @override
  Notif fromJson(data) {
    return Notif.fromJson(data);
  }

  Future<void> readNotfication(int notifId) async{
     var url = "${BaseProvider.baseUrl}$endpoint/MakeRead/$notifId";

    var uri = Uri.parse(url);

    var headers = createHeaders();

    Response response = await put(uri,
       headers: headers,
        body: null);

    if (isValidResponse(response)) {
    } else {
      throw new Exception("Unknown error");
    }
  }

}
