import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class VerificationScreeen extends StatelessWidget {
  const VerificationScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if(auth.isEmailVerified== false){
      auth.startEmailVerificationListener();
    }
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){
        auth.clearAll();
        Navigator.pushNamed(context, '/register');
      },
          icon: Icon(CupertinoIcons.back))
        ,),
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                auth.isEmailVerified ? Icons.check_circle_outline
                    :Icons.email_outlined,
                size: 40,
                color: auth.isEmailVerified ? Colors.green: null,
              ),
              const SizedBox(height: 20,),
              Text(
                auth.isEmailVerified
                    ? 'Verified'
                    : 'Please verify your email',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                auth.isEmailVerified
                    ? 'Registration successful'
                    : 'A verification link has been sent to your email.',
              ),
              if (!auth.isEmailVerified)
                const SizedBox(height: 30),
              if (!auth.isEmailVerified)
                const CircularProgressIndicator(),
              if(!auth.isEmailVerified)
                const SizedBox(height: 30,),
              if(auth.isEmailVerified)
                 TextButton(onPressed: (){
                   Navigator.pushNamed(context, '/login');
                 },
                    child: Text('Continue'))
            ],
          )
      ),
    );
  }
}
