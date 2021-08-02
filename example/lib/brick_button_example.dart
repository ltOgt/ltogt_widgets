import 'package:flutter/material.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Brick Button Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            // TODO this expand to full size all of a suddon
            child: BrickButton(
              isElevated: true,
              text: "Click Me",
              onPress: () => null,
              buildMenu: (context, rect) {
                return Positioned(
                  top: rect.bottomCenter.dy + 20,
                  left: rect.bottomCenter.dx - 200,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: const Center(child: Text("I'm a menu")),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}
