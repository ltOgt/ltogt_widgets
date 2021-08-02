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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ListGenerator.seperated(
              list: [
                const BendContainer(
                  mode: BendMode.CONVEX,
                  shape: BoxShape.circle,
                  child: SizedBox.square(
                    dimension: 100,
                  ),
                ),
                const BendContainer(
                  mode: BendMode.CONVEX,
                  child: SizedBox.square(
                    dimension: 100,
                  ),
                ),
                const BendContainer(
                  mode: BendMode.CONCAVE,
                  child: SizedBox.square(
                    dimension: 100,
                  ),
                ),
                const BendContainer(
                  mode: BendMode.CONCAVE,
                  shape: BoxShape.circle,
                  child: SizedBox.square(
                    dimension: 100,
                  ),
                ),
                const RecessContainer(
                  child: SizedBox.square(
                    dimension: 100,
                  ),
                )
              ],
              builder: (Widget w, i) => w,
              seperator: SIZED_BOX_10,
            ),
          ),
        ),
      ),
    ),
  );
}
