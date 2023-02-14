import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PayCompletedPage extends StatelessWidget {
  const PayCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pay Completed'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                FontAwesomeIcons.star,
                color: Colors.yellow,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Pay Completed!',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ));
  }
}
