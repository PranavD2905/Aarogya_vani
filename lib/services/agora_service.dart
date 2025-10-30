import 'dart:convert';
import 'package:http/http.dart' as http;

class AgoraService {
  static const String baseUrl =
      'YOUR_TOKEN_SERVER_URL'; // Replace with your token server URL
  static const String appId =
      'YOUR_AGORA_APP_ID'; // Replace with your Agora App ID

  // Generate a token for a channel
  static Future<String> getToken({
    required String channelName,
    required int uid,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rtc/$channelName/publisher/uid/$uid'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['rtcToken'];
      } else {
        throw Exception('Failed to generate token');
      }
    } catch (e) {
      // For development, return a temporary token
      // In production, always use a token server
      return 'YOUR_TEMPORARY_TOKEN';
    }
  }

  // Generate a unique channel name
  static String generateChannelName({
    required String doctorId,
    required String patientId,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'call_${doctorId}_${patientId}_$timestamp';
  }
}
