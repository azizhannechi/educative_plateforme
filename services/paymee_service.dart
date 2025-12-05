import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class PaymeeService {
  /// URL d'API Paymee
  final String sandboxUrl = 'https://sandbox.paymee.tn/api/v2/payments/create';
  final String liveUrl = 'https://app.paymee.tn/api/v2/payments/create';

  /// 🔥 À remplacer par ta clé API depuis dashboard Paymee (mode Sandbox)
  final String apiKey = "TON_API_KEY_SANDBOX_ICI";

  /// Toggle Sandbox/Prod
  final bool useSandbox = true;

  /// ******************************
  /// 🧾 Create payment request
  /// ******************************
  Future<Map<String, dynamic>> createPayment({
    required double amount,
    required String orderId,
    required String userPhone,
    required String webhookUrl,
    String? returnUrl,
    String? cancelUrl,
    String note = "Achat cours",
    String? email,
    String? firstName,
    String? lastName,
  }) async {

    final url = Uri.parse(useSandbox ? sandboxUrl : liveUrl);

    final payload = {
      "amount": amount,
      "note": note,
      "first_name": firstName ?? "Etudiant",
      "last_name": lastName ?? "StudyHub",
      "email": email ?? "no-reply@studyhub.tn",
      "phone": userPhone,
      "return_url": returnUrl ?? "https://studyhub.com/success",
      "cancel_url": cancelUrl ?? "https://studyhub.com/cancel",
      "webhook_url": webhookUrl,
      "order_id": orderId,
    };

    print("📤 Envoi Paymee → $payload");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $apiKey',
      },
      body: jsonEncode(payload),
    );

    print("📥 Paymee Status: ${response.statusCode}");
    print("📥 Paymee Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final res = jsonDecode(response.body);

      if (res["status"] == true) {
        return {
          "success": true,
          "token": res["data"]["token"],
          "payment_url": res["data"]["payment_url"],
          "order_id": res["data"]["order_id"]
        };
      }
      return {"success": false, "error": res["message"]};
    }

    return {
      "success": false,
      "error": "Erreur HTTP ${response.statusCode}: ${response.body}"
    };
  }

  /// ******************************
  /// 🔐 Compute Paymee checksum
  /// ******************************
  String generateChecksum({
    required String token,
    required bool status,
  }) {
    final paymentStatus = status ? "1" : "0";
    final raw = "$token$paymentStatus$apiKey";

    return md5.convert(utf8.encode(raw)).toString();
  }
}
