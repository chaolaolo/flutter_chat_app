import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  //text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  //tap to go to login page
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //   logo
            Icon(
              Iconsax.message_favorite5,
              size: 60,
              color: isDarkMode ? Colors.grey.shade500 : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            //   welcome back message
            Text(
              "Let's create an account for you!",
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade400 : Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            //   email textfield
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: 10),
            //   password textfield
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 10),
            //   password textfield
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmPasswordController,
            ),
            const SizedBox(height: 25),
            // login button
            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),

            const SizedBox(height: 25),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    " Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.grey.shade400 : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void register(BuildContext context) async {
    final _auth = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        _auth.signUpWithEmailPassword(_emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString(), style: TextStyle(fontSize: 18)),
            content: Text("Something went wrong"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password don't match", style: TextStyle(fontSize: 18)),
          content: Text("Please confirm your password again!"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"))
          ],
        ),
      );
    }
  }
}
