import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Brick Button Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ListGenerator.seperated(
                  list: [
                    BrickIconButton(
                      isElevated: true,
                      mode: BendMode.CONVEX,
                      onPressed: (_) {},
                      icon: Icon(Icons.star),
                    ),
                    BrickIconButton(
                      isElevated: true,
                      mode: BendMode.CONCAVE,
                      onPressed: (_) {},
                      icon: Icon(Icons.star),
                    ),
                    BrickIconButton(
                      isElevated: false,
                      mode: BendMode.CONVEX,
                      onPressed: (_) {},
                      icon: Icon(Icons.star),
                    ),
                    BrickIconButton(
                      isElevated: false,
                      mode: BendMode.CONCAVE,
                      onPressed: (_) {},
                      icon: Icon(Icons.star),
                    ),
                  ],
                  builder: (Widget w, i) => w,
                  seperator: SIZED_BOX_10,
                ),
              ),
              SIZED_BOX_10,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ListGenerator.seperated(
                  list: [
                    BrickIconButton(
                      isElevated: true,
                      mode: BendMode.CONVEX,
                      icon: Icon(Icons.star),
                    ),
                    BrickIconButton(
                      isElevated: true,
                      mode: BendMode.CONCAVE,
                      icon: Icon(Icons.star),
                    ),
                    BrickIconButton(
                      isElevated: false,
                      mode: BendMode.CONVEX,
                      icon: Icon(Icons.star),
                    ),
                    BrickIconButton(
                      isElevated: false,
                      mode: BendMode.CONCAVE,
                      icon: Icon(Icons.star),
                    ),
                  ],
                  builder: (Widget w, i) => w,
                  seperator: SIZED_BOX_10,
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
