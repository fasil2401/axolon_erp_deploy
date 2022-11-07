import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RedirectScreen extends StatefulWidget {
  const RedirectScreen({Key? key}) : super(key: key);

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  @override
  void initState() {
    super.initState();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Redirect Screen'),
      ),
    );
  }
}
