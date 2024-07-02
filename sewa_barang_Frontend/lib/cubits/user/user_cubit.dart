import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sewa_barang/models/user_model.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> fetchUserProfile() async {
    try {
      emit(UserLoading());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id_user');
      print("ini user id ${userId.toString()}");

      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/users/$userId'));

      if (response.statusCode == 200) {
        User user = User.fromJson(json.decode(response.body));
        emit(UserLoaded(user));
      } else {
        emit(UserError('Failed to load user profile'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUserProfile(User user) async {
    try {
      emit(UserLoading());
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/users/${user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullname': user.fullname,
          'contact': user.contact,
          'gender': user.gender,
          'address': user.address,
          'photo_url': user.photoUrl,
        }),
      );

      if (response.statusCode == 200) {
        User updatedUser = User.fromJson(json.decode(response.body));
        emit(UserLoaded(updatedUser));
      } else {
        emit(UserError('Failed to update user profile'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
