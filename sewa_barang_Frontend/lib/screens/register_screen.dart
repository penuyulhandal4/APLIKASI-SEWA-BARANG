import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewa_barang/cubits/auth/auth_cubit.dart';
import 'package:sewa_barang/cubits/auth/auth_state.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.blue),
                    fillColor: Colors.blue.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.blue),
                    fillColor: Colors.blue.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact',
                    labelStyle: TextStyle(color: Colors.blue),
                    fillColor: Colors.blue.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.blue),
                    fillColor: Colors.blue.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().register(
                          username: _usernameController.text,
                          password: _passwordController.text,
                          fullname: _fullnameController.text,
                          contact: _contactController.text,
                        );
                  },
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Already have an account? Log in",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
