import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewa_barang/cubits/user/user_cubit.dart';
import 'screens/splash_screen.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/items/items_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ItemsCubit()),
        BlocProvider(create: (context) => UserCubit()..fetchUserProfile()),
      ],
      child: MaterialApp(
          title: 'App Sewa Barang',
          theme: ThemeData(
            primaryColor: Colors.lightBlue,
            scaffoldBackgroundColor: Colors.lightBlue[50],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.lightBlue,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.lightBlue[900]),
              bodyText2: TextStyle(color: Colors.lightBlue[900]),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.lightBlue,
              textTheme: ButtonTextTheme.primary,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          home: SplashScreen(),
          debugShowCheckedModeBanner: false),
    );
  }
}
