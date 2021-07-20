import 'package:flutter/material.dart';
import 'package:ltogt_widgets/src/brick_button.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Brick Button Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: BrickButton(
            text: "Click Me",
            onPress: () => null,
            buildMenu: (context, rect) {
              return Positioned(
                top: rect.bottomCenter.dy + 20,
                left: rect.bottomCenter.dx - 200,
                child: Container(
                  width: 400,
                  height: 400,
                  color: Colors.grey,
                  child: const Center(child: Text("I'm a menu")),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
