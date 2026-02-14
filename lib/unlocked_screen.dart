import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnlockedScreen extends StatelessWidget {
  const UnlockedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ive unlocked instagram for you ! :p',
              style: TextStyle(color: Colors.white, fontSize: 32),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text('open instagram'),
            ),
          ],
        ),
      ),
    );
  }
}
