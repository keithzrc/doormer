// A simple page for Company Info
import 'package:flutter/material.dart';

class CompanyInfoPage extends StatelessWidget {
  const CompanyInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Info'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Company Info Page!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
