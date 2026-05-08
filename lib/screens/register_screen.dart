import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onRegistered,
    required this.onBackToIntro,
  });

  final VoidCallback onRegistered;
  final VoidCallback onBackToIntro;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration complete.')),
    );
    widget.onRegistered();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (email.isEmpty) {
      return 'Please enter your email.';
    }
    if (!emailPattern.hasMatch(email)) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Register',
      actions: [
        TextButton(
          onPressed: widget.onBackToIntro,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFEAF2FF),
          ),
          child: const Text('Intro'),
        ),
      ],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip:
                            _hidePassword ? 'Show password' : 'Hide password',
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _submit,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
