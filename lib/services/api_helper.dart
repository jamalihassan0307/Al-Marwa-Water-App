import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:al_marwa_water_app/core/utils/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  // static const String baseUrl =
  //     "https://stage2.beholdcareservices.com/public/api"; // change to your base URL
  static const String baseUrl =
      "http://al-marwa-water.clientwork.info/public/api"; // change to your base URL

  //!------------------ GET Request-------------------------------------------------
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    try {
      final response = await http.get(url);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("GET request error: $e");
    }
  }

  //!-------------------- POST Request-------------------------------------
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // 👈 Add this!
        },
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      if (e.toString().contains("Network Error")) {
        showSnackbar(
          message: "Network Error. Please try again.",
          isError: true,
        );
      } else if (e.toString().contains("Server Error")) {
        showSnackbar(
          message: "Server Error. Please try again later.",
          isError: true,
        );
      }
      throw Exception("POST request error: $e");
    }
  }

  //!------------------ GET Page Request-------------------------------------------------
  Future<dynamic> getPage(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      "$baseUrl/$endpoint",
    ).replace(queryParameters: queryParams);
    try {
      final response = await http.get(uri);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("GET request error: $e");
    }
  }

  //!------------------ Put Request helper-------------------------------------------------

  static Future<http.Response> putUpdate({
    required String endpoint,
    required Map<String, dynamic> body,
    required String token,
  }) async {
    print("error 6 in heper");
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print("error 7 in heper");

      return response;
    } catch (e) {
      print("error 8 in heper");
      log("Error in putUpdate: $e");
      throw Exception('Failed to update: $e');
    }
  }

  //!-------------------- POST image Request-------------------------------------

  Future<Map<String, dynamic>> uploadImage({
    required int customerId,
    required File imageFile,
  }) async {
    final uri = Uri.parse("$baseUrl/customers/$customerId/upload-image");

    var request = http.MultipartRequest("POST", uri);

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    try {
      final streamedResponse = await request.send();

      // ✅ Read the full response
      final responseString = await streamedResponse.stream.bytesToString();
      print("📦 Raw upload response string: $responseString");

      if (streamedResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(responseString);
        print("✅ Decoded JSON: $jsonResponse");
        return jsonResponse;
      } else {
        throw Exception(
          "Image upload failed [${streamedResponse.statusCode}]: $responseString",
        );
      }
    } catch (e) {
      throw Exception("Image upload error: $e");
    }
  }

  // Handle Response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception("Bad Request: ${response.body}");
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: ${response.body}");
    } else if (response.statusCode == 403) {
      throw Exception("Forbidden: ${response.body}");
    } else if (response.statusCode == 404) {
      throw Exception("Not Found: ${response.body}");
    } else if (response.statusCode == 500) {
      throw Exception("Server Error: ${response.body}");
    } else if (response.statusCode == 422) {
      log("Validation Error: ${response.body}");
      throw Exception("API Error: ${response.statusCode} ${response.body}");
    } else {
      // Handle other status codes
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "API Error: ${response.statusCode} ${response.reasonPhrase}",
      );
    }
  }
}
