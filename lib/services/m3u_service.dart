
import 'dart:convert';
import 'package:http/http.dart' as http;

class M3uService {
  // دالة لجلب وترتيب بيانات السيرفر أو ملف الـ M3U
  static Future> fetchServerData(String serverUrl, String username, String password) async {
    try {
      // مثال على رابط Xtream API الافتراضي لجلب معلومات الحساب
      final Uri apiUrl = Uri.parse('$serverUrl/player_api.php?username=$username&password=$password');
      
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          "success": true,
          "user_info": data['user_info'] ?? {},
          "server_info": data['server_info'] ?? {},
        };
      } else {
        return {
          "success": false,
          "message": "فشل الاتصال بالسيرفر (رمز الخطأ: ${response.statusCode})"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "حدث خطأ في الشبكة: $e"
      };
    }
  }
}
