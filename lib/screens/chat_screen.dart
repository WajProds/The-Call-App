import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: 70,
        title: const Text(
          'Chat Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 22, 33, 41),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 22, 33, 41),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 10, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(213, 255, 255, 255),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: TextField(
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            controller: _controller,
                            decoration:
                                const InputDecoration(border: InputBorder.none,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 10),
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(213, 255, 255, 255),
                    ),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.text = '';
                          });
                        },
                        icon: const Icon(
                          Icons.send_rounded,
                          size: 35,
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
