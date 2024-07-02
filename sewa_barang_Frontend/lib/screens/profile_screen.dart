import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sewa_barang/cubits/user/user_cubit.dart';
import 'edit_profile_screen.dart'; // Import EditProfileScreen

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              final userState = context.read<UserCubit>().state;
              if (userState is UserLoaded) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(user: userState.user),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final user = state.user;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoUrl.isNotEmpty
                        ? NetworkImage('http://127.0.0.1:8000${user.photoUrl}')
                        : null,
                    child: user.photoUrl.isEmpty
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    user.fullname,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '@${user.username}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Contact: ${user.contact}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Gender: ${user.gender ?? 'Not specified'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Address: ${user.address}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Member since: ${DateFormat('dd MMMM yyyy').format(user.createAt)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}
