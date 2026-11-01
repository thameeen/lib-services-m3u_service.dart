import 'dart:convert';
import 'package:http/http.dart' as http;

class M3uService {
  static Future authenticateUser(String serverUrl, String username, String password) async {
    try {
      final cleanUrl = serverUrl.endsWith('/') ? serverUrl.substring(0, serverUrl.length - 1) : serverUrl;
      final url = Uri.parse('$cleanUrl/player_api.php?username=$username&password=$password');
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['user_info'] != null && data['user_info']['auth'] == 1) {
          return {
            "success": true,
            "user_info": data['user_info'],
            "server_info": data['server_info'],
          };
        } else {
          return {
            "success": false,
            "message": "اسم المستخدم أو كلمة المرور غير صحيحة"
          };
        }
      } else {
        return {
          "success": false,
          "message": "فشل الاتصال بالسيرفر"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "تعذر الاتصال بالسيرفر"
      };
    }
  }
}
