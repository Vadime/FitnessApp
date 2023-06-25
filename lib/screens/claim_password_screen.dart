import 'package:flutter/material.dart';

class ClaimPasswordScreen extends StatefulWidget {
  const ClaimPasswordScreen({super.key});

  @override
  State<ClaimPasswordScreen> createState() => _ClaimPasswordScreenState();
}

class _ClaimPasswordScreenState extends State<ClaimPasswordScreen> {
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
                        obscureText: passVisible,
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Forgot Password')));
                  },
                  child: const Text('Forgot Password'),
                ),
              ),
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
