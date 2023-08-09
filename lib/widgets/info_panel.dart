import 'package:flutter/material.dart';

Widget panel(bool viewPanel, List<String> infoStrings) {
  return Visibility(
    visible: viewPanel,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 150),
      child: ListView.builder(
        reverse: true,
        itemCount: infoStrings.length,
        itemBuilder: (BuildContext context, index) {
          if (infoStrings.isEmpty) {
            return const Text("null");
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      infoStrings[index],
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    ),
  );
}
