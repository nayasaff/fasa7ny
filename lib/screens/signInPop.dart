import 'package:flutter/material.dart';

class SignInPop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Sign In',
        style: TextStyle(color: Colors.black),
      ),
      content: Text(
        'You need to sign in to use this feature',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: Text('Sign In'),
        ),
      ],
    );
  }
}
