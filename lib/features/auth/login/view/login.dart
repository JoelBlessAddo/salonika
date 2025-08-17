import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salonika/features/auth/signup/view/signup.dart';
import 'package:salonika/utils/bottom_nav.dart';
import '../../../../utils/colors.dart';
import '../../auth_view_model/auth_vm.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final auth = Provider.of<AuthViewModel>(context, listen: false);

    await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!), backgroundColor: Colors.red),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BottomNav(pageIndex: 0)),
      (route) => false,
    );
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _submitting = true);
    final auth = Provider.of<AuthViewModel>(context, listen: false);

    await auth.signInWithGoogle();

    if (!mounted) return;
    setState(() => _submitting = false);

    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!), backgroundColor: Colors.red),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BottomNav(pageIndex: 0)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                height: 100,
                width: 100,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Image.asset('assets/tractor.jpg', fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter your email';
                  final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
                  return ok ? null : 'Enter a valid email';
                },
              ),
              const SizedBox(height: 20),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter your password' : null,
                onFieldSubmitted: (_) => _handleEmailLogin(),
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: navigate to Forgot Password screen
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: GREEN, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GREEN,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitting ? null : _handleEmailLogin,
                  child: Text(
                    _submitting ? 'Loading…' : 'Login',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Divider
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFF707070),
                      endIndent: 10,
                    ),
                  ),
                  Text('or sign in with'),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFF707070),
                      indent: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Google sign-in
              GestureDetector(
                onTap: _submitting ? null : _handleGoogleLogin,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/G.png', scale: 4),
                ),
              ),

              const SizedBox(height: 40),

              // Go to SignUp
              GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const Register()));
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: GREEN,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
