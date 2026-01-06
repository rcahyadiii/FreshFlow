import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/onboarding/data/auth_repository.dart';
import '../data/profile_repository.dart';

class EditProfileFieldScreen extends StatefulWidget {
  final String fieldKey;
  final String currentValue;
  const EditProfileFieldScreen({super.key, required this.fieldKey, required this.currentValue});

  @override
  State<EditProfileFieldScreen> createState() => _EditProfileFieldScreenState();
}

class _EditProfileFieldScreenState extends State<EditProfileFieldScreen> {
  late TextEditingController _controller;
  bool _saving = false;
  late String _initial;
  DateTime? _initialDob;
  DateTime? _dob;
  String? _initialGender;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
    _initial = widget.currentValue;
    _controller.addListener(() => setState(() {}));
    if (widget.fieldKey == 'Date of Birth') {
      final repo = context.read<ProfileRepository>();
      _initialDob = repo.dateOfBirth;
      _dob = _initialDob;
    }
    if (widget.fieldKey == 'Gender') {
      final repo = context.read<ProfileRepository>();
      _initialGender = repo.gender;
      _gender = _initialGender;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    if (widget.fieldKey == 'Date of Birth') {
      context.read<ProfileRepository>().setDateOfBirth(_dob);
    } else if (widget.fieldKey == 'Gender') {
      context.read<ProfileRepository>().updateField('Gender', _gender ?? '');
    } else if (widget.fieldKey == 'Username') {
      final newVal = _controller.text.trim();
      await context.read<AuthRepository>().setUsername(newVal);
      context.read<ProfileRepository>().updateField(widget.fieldKey, newVal);
    } else {
      context.read<ProfileRepository>().updateField(widget.fieldKey, _controller.text.trim());
    }
    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  String? _validate(String key, String value) {
    if (key == 'Name') {
      if (value.isEmpty) return 'Name is required';
      if (value.length < 2) return 'Name is too short';
    } else if (key == 'Username') {
      if (value.isEmpty) return 'Username is required';
      final re = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
      if (!re.hasMatch(value)) return '3-20 chars, letters/numbers/_ only';
    } else if (key == 'Email') {
      if (value.isEmpty) return 'Email is required';
      final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!re.hasMatch(value)) return 'Enter a valid email';
    } else if (key == 'Phone Number') {
      if (value.isEmpty) return 'Phone number is required';
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length < 8) return 'Enter at least 8 digits';
    } else if (key == 'Address') {
      if (value.isEmpty) return 'Address is required';
    } else if (key == 'Bio') {
      if (value.length > 200) return 'Max 200 characters';
    }
    return null;
  }

  TextInputType _keyboardFor(String key) {
    switch (key) {
      case 'Email':
        return TextInputType.emailAddress;
      case 'Phone Number':
        return TextInputType.phone;
      case 'Address':
        return TextInputType.streetAddress;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> _formattersFor(String key) {
    switch (key) {
      case 'Username':
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))];
      default:
        return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text.trim();
    final isDob = widget.fieldKey == 'Date of Birth';
    final isGender = widget.fieldKey == 'Gender';
    const genderOptions = ['Male', 'Female'];
    final dropdownValue = genderOptions.contains(_gender) ? _gender : null;
    final dirty = isDob
        ? _dob != _initialDob
        : isGender
            ? _gender != _initialGender
            : text != _initial;
    final error = (isDob || isGender) ? null : _validate(widget.fieldKey, text);
    final valid = isDob
        ? _dob != null
        : isGender
            ? _gender != null
            : error == null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primary),
        title: Text('Edit ${widget.fieldKey}', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isDob
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final now = DateTime.now();
                        final initial = _dob ?? DateTime(now.year - 18, now.month, now.day);
                        final first = DateTime(1900, 1, 1);
                        final last = DateTime(now.year, now.month, now.day);
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: initial,
                          firstDate: first,
                          lastDate: last,
                          helpText: 'Select Date of Birth',
                          builder: (ctx, child) {
                            return Theme(
                              data: Theme.of(ctx).copyWith(
                                colorScheme: Theme.of(ctx).colorScheme.copyWith(
                                      primary: AppTheme.primary,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _dob = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dob == null
                                  ? 'Tap to select date'
                                  : '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: AppTheme.primary),
                            ),
                            const Icon(Icons.calendar_today, size: 18, color: AppTheme.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : isGender
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: dropdownValue,
                          items: genderOptions
                              .map((g) => DropdownMenuItem<String>(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (v) => setState(() => _gender = v),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primary),
                            ),
                          ),
                          iconEnabledColor: AppTheme.primary,
                        ),
                      ],
                    )
                  : TextField(
                      controller: _controller,
                      keyboardType: _keyboardFor(widget.fieldKey),
                      inputFormatters: _formattersFor(widget.fieldKey),
                      maxLines: widget.fieldKey == 'Address' || widget.fieldKey == 'Bio' ? 4 : 1,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: widget.fieldKey,
                        border: const OutlineInputBorder(),
                        errorText: error,
                        counterText: widget.fieldKey == 'Bio' ? '${text.length}/200' : null,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primary),
                        ),
                      ),
                      cursorColor: AppTheme.primary,
                    ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: (_saving || !dirty || !valid) ? null : _save,
              style: FilledButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
              child: _saving ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white) : const Text('Save Changes'),
            ),
          ),
        ),
      ),
    );
  }
}
