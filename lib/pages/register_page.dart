import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';
import '/utils/ui_helpers.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final repeatPassword = TextEditingController();

  String error = "";
  bool loading = false;
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF020024), Color(0xFF090979), Color(0xFF00D4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 40,
                    spreadRadius: 2,
                    color: Colors.blue.withOpacity(.3),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add, size: 70, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text(
                    "Реєстрація",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: name,
                    style: const TextStyle(color: Colors.white),
                    decoration: authInput("Імʼя").copyWith(
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: email,
                    style: const TextStyle(color: Colors.white),
                    decoration: authInput("Email").copyWith(
                      prefixIcon:
                          const Icon(Icons.email, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: password,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: authInput("Пароль").copyWith(
                      prefixIcon:
                          const Icon(Icons.lock, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: repeatPassword,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: authInput("Повторіть пароль").copyWith(
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.white),
                    ),
                  ),

                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(error,
                        style: const TextStyle(color: Colors.yellow)),
                  ],

                  const SizedBox(height: 20),

                  loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade900,
                            minimumSize:
                                const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            if (_navigated) return;

                            if (password.text != repeatPassword.text) {
                              setState(() =>
                                  error = "Паролі не співпадають");
                              return;
                            }

                            setState(() {
                              loading = true;
                              error = "";
                            });

    final msg = await auth.register(
  name.text.trim(),
  email.text.trim(),
  password.text.trim(),
);


                            setState(() => loading = false);

                            if (msg != null) {
                              setState(() => error = msg);
                            } else {
                              _navigated = true;
                              await auth.logout();
                              Navigator.of(context).pushReplacement(
                                fadeRoute(const LoginPage()),
                              );
                            }
                          },
                          child: const Text(
                            "Зареєструватися",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(fadeRoute(const LoginPage()));
                    },
                    child: const Text(
                      "Вже є акаунт? Увійти",
                      style: TextStyle(
                        color: Colors.white70,
                        decoration: TextDecoration.underline,
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
