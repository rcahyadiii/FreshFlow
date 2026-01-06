import 'package:flutter/material.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:freshflow_app/features/onboarding/data/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _obscure = true;
  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        'Welcome to Fresh Flow!',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Username field
                      Text(
                        'Username',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
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

                      // Password field
                      Text(
                        'Password',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscure,
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
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure ? Icons.visibility : Icons.visibility_off,
                              color: AppTheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: _rememberMe,
                            onChanged: (v) => setState(() => _rememberMe = v ?? false),
                            activeColor: AppTheme.primary,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(
                            'Remember Password',
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.black),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: Text(
                              'Forgot Password?',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.black, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      // Primary button: Log In
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final ok = _validate();
                            if (ok) {
                              Navigator.of(context).pushReplacementNamed('/');
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
                          child: const Text('Log In'),
                        ),
                      ),

                      const SizedBox(height: 12),
                      // Secondary button: Register (outlined)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/register');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.primary, width: 1),
                            foregroundColor: AppTheme.primary,
                            minimumSize: const Size(double.infinity, 48),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          child: const Text('Register'),
                        ),
                      ),

                      // Small freeflow.svg below Register button
                      const SizedBox(height: 12),
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

extension _LoginValidation on _LoginPageState {
  bool _validate() {
    String? userErr;
    String? passErr;

    final repo = context.read<AuthRepository>();
    final username = _usernameController.text.trim();
    final pass = _passwordController.text;

    if (!repo.hasUser || !repo.usernameExists(username)) {
      userErr = 'Username not found';
    } else if (!repo.validate(username, pass)) {
      passErr = 'Password Wrong';
    }

    // ignore: invalid_use_of_protected_member
    setState(() {
      _usernameError = userErr;
      _passwordError = passErr;
    });

    return userErr == null && passErr == null;
  }
}
