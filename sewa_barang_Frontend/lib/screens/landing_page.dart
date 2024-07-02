import 'package:flutter/material.dart';
import 'package:sewa_barang/screens/login_screen.dart';
import 'package:sewa_barang/screens/register_screen.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
            ),
            Image.asset('assets/images/splash.png',
                width: 100, height: 100), // Mengurangi ukuran gambar
            SizedBox(height: 20),
            Text(
              'Sewa Barang',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Mengganti warna teks menjadi hitam
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Masuk'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text('Daftar'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Sewa barang dengan mudah &\npastinya semua ada di sini',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Mengganti warna teks menjadi hitam
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Aksi untuk membuka Google
                  },
                  child: Image.asset('assets/images/google.png',
                      width: 30, height: 30),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    // Aksi untuk membuka Facebook
                  },
                  child: Image.asset('assets/images/facebook.png',
                      width: 30, height: 30),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
