import 'package:burnfat/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BurnFat')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('Sign Up',
                  style: Theme.of(context).textTheme.headlineMedium),
              Row(
                children: [
                  const Text('I already have an account!'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignInScreen()),
                          (_) => false);
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
              const Spacer(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Email',
                        ),
                      ),
                      TextField(
                        obscureText: !passVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(passVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  passVisible = !passVisible;
                                });
                              }),
                          border: InputBorder.none,
                          labelText: 'Password',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Sign Up')));
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
