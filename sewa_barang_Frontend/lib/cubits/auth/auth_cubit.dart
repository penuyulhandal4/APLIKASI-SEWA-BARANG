import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> register({
    required String username,
    required String password,
    required String fullname,
    required String contact,
  }) async {
    emit(AuthLoading());
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/auth/register/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'fullname': fullname,
        'contact': contact,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      emit(AuthSuccess(data['message']));
    } else {
      emit(AuthFailure('Registration Failed'));
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/auth/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['data']['access_token']);
      await prefs.setInt(
          'id_user', data['data']['id_user']); // Use setInt for storing integer
      print("berhasil login");

      // Check if the id_user is saved correctly
      int? idUser = prefs.getInt('id_user');
      print("id_user from shared preferences: $idUser");

      emit(AuthSuccess('Login Successful'));
    } else {
      emit(AuthFailure('Login Failed'));
    }
  }
}
