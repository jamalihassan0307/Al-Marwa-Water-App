// // api_helper.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiHelper {
//   static Future<Map<String, dynamic>> getData(String url) async {
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }
