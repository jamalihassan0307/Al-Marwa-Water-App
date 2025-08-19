import 'package:al_marwa_water_app/services/api_helper.dart';

class AuthRepository {
  final ApiHelper apiHelper = ApiHelper();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiHelper.post('login', {
      'user_code': email,
      'password': password,
    });
    
    return response;

  }
}
