import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../data/profile_repository.dart';
import 'edit_profile_field_screen.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/onboarding/data/auth_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }

  Widget _row(BuildContext context, {required String label, required String value}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EditProfileFieldScreen(fieldKey: label, currentValue: value),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(label, style: const TextStyle(color: Color(0xFFBABBBB))),
            ),
            Expanded(child: Text(value, style: const TextStyle(color: Colors.black))),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ProfileRepository>();
    final username = context.select<AuthRepository, String?>((a) => a.username);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: AppTheme.primary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.antiAlias,
                      child: repo.photoPath == null || repo.photoPath!.isEmpty
                          ? Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.person, size: 48, color: Colors.grey),
                            )
                          : Image.file(File(repo.photoPath!), fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 1024);
                        if (picked != null) {
                          // Save selected photo path
                          // ignore: use_build_context_synchronously
                          context.read<ProfileRepository>().setPhotoPath(picked.path);
                        }
                      },
                      style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
                      child: const Text('Change Profile Photo'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _sectionTitle('Profile Information'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _row(context, label: 'Name', value: repo.name),
                      const Divider(height: 1),
                      _row(context, label: 'Username', value: (username ?? '—')),
                      const Divider(height: 1),
                      _row(context, label: 'Bio', value: repo.bio),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _sectionTitle('Personal Information'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _row(context, label: 'Gender', value: repo.gender),
                      const Divider(height: 1),
                      _row(context, label: 'Date of Birth', value: repo.valueFor('Date of Birth')),
                      const Divider(height: 1),
                      _row(context, label: 'Address', value: repo.address),
                      const Divider(height: 1),
                      _row(context, label: 'Email', value: repo.email),
                      const Divider(height: 1),
                      _row(context, label: 'Phone Number', value: repo.phone),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Placeholder for deactivate account
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Deactivate account placeholder')), 
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Deactivate Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
