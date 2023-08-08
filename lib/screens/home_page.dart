import 'package:flutter/material.dart';

import '../widgets/role_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController joinController = TextEditingController();
  final TextEditingController hostController = TextEditingController();

  @override
  void dispose() {
    joinController.dispose();
    hostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 183, 214, 234),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Voice Call',
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 183, 214, 234),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 40),
            roleSelector(1, hostController, joinController, context),
            const SizedBox(height: 10),
            roleSelector(2, hostController, joinController, context),
          ],
        ),
      ),
    );
  }
}
