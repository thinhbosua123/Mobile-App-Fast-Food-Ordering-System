import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_ui/screens/forgot_password_screen.dart';
import 'package:food_app_ui/screens/signup_screen.dart';
import 'package:food_app_ui/screens/home_screen.dart';
import 'package:food_app_ui/admin/admin_screen.dart';
import 'package:flutter/services.dart';
import 'package:food_app_ui/screens/user_info_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _loginWithEmailAndPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackbar('Email và mật khẩu không được để trống');
      return;
    }

    if (!email.endsWith('@gmail.com')) {
      _showErrorSnackbar('Email phải kết thúc bằng @gmail.com');
      return;
    }

    if (password.length < 6) {
      _showErrorSnackbar('Mật khẩu phải từ 6 ký tự trở lên');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      DocumentSnapshot userData = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userData.exists) {
        int role = userData['role'] ?? 0;
        bool hasUserInfo = userData['height'] != null &&
            userData['weight'] != null &&
            userData['activityLevel'] != null &&
            userData['goal'] != null;

        if (role == 1) {
          // Navigate to Admin Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
        } else if (!hasUserInfo) {
          // If user hasn't filled in the additional info, navigate to UserInfoScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoScreen(userUid: '',)),
          );
        } else {
          // Navigate to Home Screen if everything is okay
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        _showErrorSnackbar('Thông tin đăng nhập sai. Vui lòng thử lại.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorSnackbar('Tài khoản chưa được đăng ký, vui lòng đăng ký!');
      } else if (e.code == 'wrong-password') {
        _showErrorSnackbar('Mật khẩu không chính xác!');
      } else {
        _showErrorSnackbar('Đã xảy ra lỗi. Vui lòng thử lại.');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.deepOrangeAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 60),
                _buildLogo(),
                const SizedBox(height: 30),
                Text(
                  'Đăng Nhập',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                _buildTextField(_emailController, 'Email', Icons.email),
                const SizedBox(height: 20),
                _buildTextField(_passwordController, 'Mật Khẩu', Icons.lock,
                    isObscure: true),
                const SizedBox(height: 10),
                _buildForgotPasswordLink(),
                const SizedBox(height: 20),
                _buildLoginButton(),
                const SizedBox(height: 20),
                _buildSignUpLink(),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Image.asset(
        'assets/images/img.png',
        height: 100,
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isObscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        inputFormatters: [
          LowerCaseTextFormatter(),
        ],
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _loginWithEmailAndPassword,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'Đăng Nhập',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
              const ForgotPassword(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Text(
            'Quên mật khẩu?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUp(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          text: 'Chưa có tài khoản? ',
          style: const TextStyle(color: Colors.white, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: 'Đăng ký ngay!',
              style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
