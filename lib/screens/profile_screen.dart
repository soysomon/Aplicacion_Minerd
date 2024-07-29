import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<ProfileProvider>(context, listen: false).setProfileImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return CircleAvatar(
                  backgroundImage: profileProvider.profileImage.isNotEmpty
                      ? FileImage(File(profileProvider.profileImage))
                      : AssetImage('assets/profile_placeholder.png'),
                  radius: 50,
                );
              },
            ),
            ElevatedButton(
              onPressed: () => _pickImage(context),
              child: Text('Change Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
