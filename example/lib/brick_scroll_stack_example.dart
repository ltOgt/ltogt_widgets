import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Scroll Stack Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: BrickScrollStackExample(),
        ),
      ),
    ),
  );
}

class BrickScrollStackExample extends StatefulWidget {
  const BrickScrollStackExample({
    Key? key,
  }) : super(key: key);

  @override
  State<BrickScrollStackExample> createState() => _BrickScrollStackExampleState();
}

class _BrickScrollStackExampleState extends State<BrickScrollStackExample> {
  bool leading = true;
  bool leadingShadow = true;
  bool trailing = true;
  bool trailingShadow = true;

  bool leadingCross = true;
  bool leadingCrossShadow = true;
  bool trailingCross = true;
  bool trailingCrossShadow = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: BrickScrollStack(
            scrollDirection: Axis.horizontal,
            leading: !leading
                ? null
                : Container(
                    color: Colors.white,
                    width: 20,
                  ),
            leadingShadow: !leadingShadow
                ? null
                : [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(-1, 0),
                    ),
                  ],
            trailing: !trailing
                ? null
                : Container(
                    color: Colors.white,
                    width: 20,
                  ),
            trailingShadow: !trailingShadow
                ? null
                : [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(1, 0),
                    ),
                  ],
            leadingCross: !leadingCross
                ? null
                : Container(
                    height: 3,
                    color: Colors.grey,
                  ),
            leadingCrossShadow: !leadingCrossShadow
                ? null
                : [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
            trailingCross: !trailingCross
                ? null
                : Container(
                    height: 3,
                    color: Colors.grey,
                  ),
            trailingCrossShadow: !trailingCrossShadow
                ? null
                : [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(0, -1),
                    ),
                  ],
            children: ListGenerator.forRange(
              to: 20,
              generator: (int index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blue,
                  width: 100,
                ),
              ),
            ),
          ),
        ),
        SIZED_BOX_10,
        Align(
          alignment: Alignment.bottomCenter,
          child: BrickScrollStack(
            scrollDirection: Axis.horizontal,
            crossAxisSize: 35,
            leadingShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(-1, 0),
              ),
            ],
            trailingShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(1, 0),
              ),
            ],
            children: ListGenerator.seperated(
              seperator: SIZED_BOX_10,
              leadingSeperator: true,
              trailingSeperator: true,
              builder: (Widget w, i) => w,
              list: [
                // ------------------------------------------ leading
                BrickButton(
                  isActive: leading,
                  text: "leading",
                  onPress: () => setState(() {
                    leading = !leading;
                  }),
                ),
                BrickButton(
                  isActive: leadingShadow,
                  text: "leadingShadow",
                  onPress: () => setState(() {
                    leadingShadow = !leadingShadow;
                  }),
                ),
                // ------------------------------------------ trailing
                BrickButton(
                  isActive: trailing,
                  text: "trailing",
                  onPress: () => setState(() {
                    trailing = !trailing;
                  }),
                ),
                BrickButton(
                  isActive: trailingShadow,
                  text: "trailingShadow",
                  onPress: () => setState(() {
                    trailingShadow = !trailingShadow;
                  }),
                ),
                // ------------------------------------------ leadingCross
                BrickButton(
                  isActive: leadingCross,
                  text: "leadingCross",
                  onPress: () => setState(() {
                    leadingCross = !leadingCross;
                  }),
                ),
                BrickButton(
                  isActive: leadingCrossShadow,
                  text: "leadingCrossShadow",
                  onPress: () => setState(() {
                    leadingCrossShadow = !leadingCrossShadow;
                  }),
                ),
                // ------------------------------------------ trailingCross
                BrickButton(
                  isActive: trailingCross,
                  text: "trailingCross",
                  onPress: () => setState(() {
                    trailingCross = !trailingCross;
                  }),
                ),
                BrickButton(
                  isActive: trailingCrossShadow,
                  text: "trailingCrossShadow",
                  onPress: () => setState(() {
                    trailingCrossShadow = !trailingCrossShadow;
                  }),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
