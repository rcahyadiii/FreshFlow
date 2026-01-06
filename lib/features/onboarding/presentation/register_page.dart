import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:freshflow_app/features/onboarding/data/auth_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  String? _usernameError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: color, width: 1),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
            onPressed: () {
              final nav = Navigator.of(context);
              if (nav.canPop()) {
                nav.pop();
              } else {
                nav.pushReplacementNamed('/login');
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Create your account',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Username
                      Text('Username', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.black)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _usernameController,
                        onChanged: (_) {
                          if (_usernameError != null) setState(() => _usernameError = null);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Username',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          border: _border(AppTheme.primary),
                          enabledBorder: _border(AppTheme.primary),
                          focusedBorder: _border(AppTheme.primary),
                          hintStyle: const TextStyle(color: Color(0xFFBABBBB), fontSize: 12),
                          errorText: _usernameError,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Phone Number
                      Text('Phone Number', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.black)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) {
                          if (_phoneError != null) setState(() => _phoneError = null);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Phone Number',
                          prefixText: '+62 ',
                          prefixStyle: const TextStyle(color: Colors.black, fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          border: _border(AppTheme.primary),
                          enabledBorder: _border(AppTheme.primary),
                          focusedBorder: _border(AppTheme.primary),
                          hintStyle: const TextStyle(color: Color(0xFFBABBBB), fontSize: 12),
                          errorText: _phoneError,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password
                      Text('Password', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.black)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePass,
                        onChanged: (_) {
                          if (_passwordError != null) setState(() => _passwordError = null);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          border: _border(AppTheme.primary),
                          enabledBorder: _border(AppTheme.primary),
                          focusedBorder: _border(AppTheme.primary),
                          hintStyle: const TextStyle(color: Color(0xFFBABBBB), fontSize: 12),
                          errorText: _passwordError,
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscurePass = !_obscurePass),
                            icon: Icon(
                              _obscurePass ? Icons.visibility : Icons.visibility_off,
                              color: AppTheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Confirm Password
                      Text('Confirm Password', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.black)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        onChanged: (_) {
                          if (_confirmError != null) setState(() => _confirmError = null);
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          border: _border(AppTheme.primary),
                          enabledBorder: _border(AppTheme.primary),
                          focusedBorder: _border(AppTheme.primary),
                          hintStyle: const TextStyle(color: Color(0xFFBABBBB), fontSize: 12),
                          errorText: _confirmError,
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                              color: AppTheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Primary button: Register
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final ok = _validate();
                            if (ok) {
                              final username = _usernameController.text.trim();
                              final phone = '+62 ${_phoneController.text}';
                              final password = _passwordController.text;
                              context.read<AuthRepository>().register(
                                    username: username,
                                    phone: phone,
                                    password: password,
                                  );
                              // After successful registration, go back to Login
                              Navigator.of(context).pushReplacementNamed('/login');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          child: const Text('Register'),
                        ),
                      ),

                      // Small logo below Register button
                      const SizedBox(height: 16),
                      Center(
                        child: Image.asset(
                          'assets/icons/freshflow.png',
                          width: 64,
                          height: 64,
                        ),
                      ),

                      const Spacer(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Helper reserved for future use
// bool _isBlank(String? s) => s == null || s.trim().isEmpty;

extension _RegisterValidation on _RegisterPageState {
  bool _validate() {
    String? userErr;
    String? phoneErr;
    String? passErr;
    String? confirmErr;

    final user = _usernameController.text.trim();
    if (user.length < 4) {
      userErr = 'Username must be at least 4 letters';
    }

    final digits = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 8) {
      phoneErr = 'Phone number must be at least 8 digits';
    }

    final pass = _passwordController.text;
    if (pass.length < 8) {
      passErr = 'Password must be at least 8 characters';
    }

    final confirm = _confirmController.text;
    if (confirm != pass) {
      confirmErr = 'Passwords do not match';
    }

    // ignore: invalid_use_of_protected_member
    setState(() {
      _usernameError = userErr;
      _phoneError = phoneErr;
      _passwordError = passErr;
      _confirmError = confirmErr;
    });

    return userErr == null && phoneErr == null && passErr == null && confirmErr == null;
  }
}
