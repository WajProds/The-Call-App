import 'package:flutter/material.dart';
import 'package:looper/screens/call.dart';
import 'package:looper/screens/new_call.dart';
import 'package:looper/utils/constants.dart';

Widget roleSelector(int role, TextEditingController joinController,
    TextEditingController hostController, BuildContext context) {
  // ignore: unused_local_variable
  String? channelID;
  final controller = role == 1 ? hostController : joinController;

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
        Text(
          role == 1 ? 'Host a call' : 'Join a call',
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Container(
                constraints:
                    const BoxConstraints(maxWidth: 200, maxHeight: 200),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: role != 1
                      ? const AssetImage(
                          'assets/1.png',
                        )
                      : const AssetImage('assets/2.png'),
                )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    role == 1 ? 'Create channel' : 'Join a channel',
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: controller,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      channelID = controller.text;
                      controller.text = '';
                      print(role == 1 ? channelID : 'joining');

                      if (channelID == channelName) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CallScreenNew(
                                      role: role,
                                      channelName: channelName,
                                    )));
                      } else {
                        showAlertDialog(context);
                      }
                    },
                    child: Text(
                      role == 1 ? 'Create' : 'Join',
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
          height: 35,
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
