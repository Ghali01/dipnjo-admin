import 'package:admin/logic/models/notification.dart';
import 'package:admin/utilities/server.dart';
import 'package:http/http.dart' as http;

class NotificiationAPI {
  static Future<void> send(TargetType type, String title, String body,
      {int? from, int? to, int? id}) async {
    http.Response response =
        await Server.send(http.post, 'accounts/send-noti', body: {
      "targetType": type.name,
      "id": id,
      "range": "$from-$to",
      "title": title,
      "body": body
    });
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }
}
