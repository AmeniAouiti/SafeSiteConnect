import 'package:flutter/material.dart';
import 'ChangePasswordScreen.dart';
import 'SignInScreen.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  VerifyCodeScreenState createState() => VerifyCodeScreenState();
}

class VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _otpController.text.isNotEmpty &&
          _otpController.text.length == 6 &&
          RegExp(r'^\d{6}$').hasMatch(_otpController.text);
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF005B96),
                Color(0xFFE8F5E8),
                Color(0xFFF0F0F0),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 30),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: _buildForm(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/1024.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF005B96),
                        Color(0xFF7ED957),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 40,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Vérification OTP',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Entrez le code reçu par email',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOtpField(),
            const SizedBox(height: 20),
            _buildVerifyButton(),
            const SizedBox(height: 16),
            _buildBackToSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _otpController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'Code OTP',
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7ED957).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.security,
              color: Colors.white.withOpacity(0.9),
              size: 18,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF7ED957),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer le code OTP';
          }
          if (!RegExp(r'^\d{6}$').hasMatch(value)) {
            return 'Le code OTP doit être composé de 6 chiffres';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: _isButtonEnabled
            ? const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF7ED957),
            Color(0xFF005B96),
          ],
        )
            : LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isButtonEnabled
            ? [
          BoxShadow(
            color: const Color(0xFF7ED957).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: _isButtonEnabled
            ? () {
          if (_formKey.currentState!.validate()) {
            // Navigate to ChangePasswordScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen()),
            );
          }
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Vérifier le code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Retour à la connexion',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}