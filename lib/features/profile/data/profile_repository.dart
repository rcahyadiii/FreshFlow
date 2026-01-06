import 'package:flutter/foundation.dart';

class ProfileRepository extends ChangeNotifier {
  String? photoPath;
  String name;
  String username;
  String bio;
  String gender;
  DateTime? dateOfBirth;
  String address;
  String email;
  String phone;

  ProfileRepository({
    this.photoPath,
    this.name = 'John Doe',
    this.username = 'johnd',
    this.bio = 'Hello there!',
    this.gender = 'Not specified',
    this.dateOfBirth,
    this.address = '—',
    this.email = 'john@example.com',
    this.phone = '+62 812-1234-5678',
  });

  void updateField(String key, String value) {
    switch (key) {
      case 'Name':
        name = value;
        break;
      case 'Username':
        username = value;
        break;
      case 'Bio':
        bio = value;
        break;
      case 'Gender':
        gender = value;
        break;
      case 'Date of Birth':
        // Prefer using setDateOfBirth; ignore string input here.
        break;
      case 'Address':
        address = value;
        break;
      case 'Email':
        email = value;
        break;
      case 'Phone Number':
        phone = value;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  String valueFor(String key) {
    switch (key) {
      case 'Name':
        return name;
      case 'Username':
        return username;
      case 'Bio':
        return bio;
      case 'Gender':
        return gender;
      case 'Date of Birth':
        return dateOfBirth == null ? '—' : '${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}';
      case 'Address':
        return address;
      case 'Email':
        return email;
      case 'Phone Number':
        return phone;
      default:
        return '—';
    }
  }

  void setPhotoPath(String? path) {
    photoPath = path;
    notifyListeners();
  }

  void setDateOfBirth(DateTime? date) {
    dateOfBirth = date;
    notifyListeners();
  }
}
