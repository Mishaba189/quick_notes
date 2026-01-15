import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final log = context.watch<AuthProvider>();
    final disable = log.isPasswordResetting
        ? log.logEmailController.text.trim().isEmpty ||
        log.isLoading ||
        log.isResetEmailSent
        : log.logEmailController.text.trim().isEmpty ||
        log.logPasswordController.text.trim().isEmpty ||
        log.isLoading;
    return Scaffold(
      appBar: log.isPasswordResetting ? AppBar(
        leading: IconButton(onPressed: (){
          log.disableResetting();
        },
            icon: Icon(CupertinoIcons.back)
        ),
      )
          :null,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              log.isPasswordResetting
              ? 'Reset Password':'Login' ,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: log.logEmailController,
              decoration: InputDecoration(
                // errorText: log.emailError,
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // onChanged: log.checkEmail,
            ),
            if(!log.isPasswordResetting)
            SizedBox(height: 16),
            if(!log.isPasswordResetting)
            TextField(
              controller: log.logPasswordController,
              obscureText: !log.isVisible3,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: log.toggleVisibility3,
                  icon: Icon(
                    log.isVisible3 ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: disable
                    ? null
                    : () async {
                  if(log.isPasswordResetting){
                    await log.resetPassword(
                      context,
                      log.logEmailController.text.trim(),
                    );
                    // log.clearAll();
                  }else {
                    try {
                      await log.login(
                        log.logEmailController.text.trim(),
                        log.logPasswordController.text.trim(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login successful')),
                      );
                      Navigator.pushNamed(context, '/home');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
                    }
                  }
                      },
                child: log.isLoading
                    ? Text('loading')
                    :  Text(log.isPasswordResetting ?'Send Reset Email' : 'Login'),
              ),
            ),
            if (log.isPasswordResetting && log.isResetEmailSent) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: log.isLoading
                    ? null
                    : () async {
                  await log.resetPassword(
                    context,
                    log.logEmailController.text.trim(),
                  );
                },
                child: const Text('Resend Email'),
              ),
            ],
            if(log.isPasswordResetting)
              SizedBox(height: 100,),
            if(!log.isPasswordResetting)
            TextButton(
              onPressed: () {
                log.clearAll();
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Create new account'),
            ),
            if(!log.isPasswordResetting)
            TextButton(
              onPressed: () {
                log.enableResetting();
              },
              child: const Text('Forgot Password?'),
            )
          ],
        ),
      ),
    );
  }
}
