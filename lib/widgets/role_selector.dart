import 'package:flutter/material.dart';
// import 'package:looper/screens/call.dart';
// import 'package:looper/screens/new_call.dart';
import 'package:looper/utils/constants.dart';

import '../screens/call.dart';

Widget roleSelector(
    TextEditingController joinController, BuildContext context) {
  // ignore: unused_local_variable
  String? channelID;
  final controller = joinController;

  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 16, 24, 29),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Join Channel',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Channel ID'),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      channelID = controller.text;
                      controller.text = '';

                      if (channelID == channelName) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CallScreen(
                                      channelName: channelName,
                                    )));
                      } else {
                        showAlertDialog(context);
                      }
                    },
                    child: Text(
                      'Join',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.indigo[700],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    ),
  );
}

showAlertDialog(context) {
  Widget okButton = TextButton(
    child: const Text("ok"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Exception"),
    content: const Text("This Channel does not exist!"),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
