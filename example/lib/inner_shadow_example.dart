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
                const ConcaveCircle(
                  child: SizedBox.square(
                    dimension: 100,
                  ),
                ),
                const ConcaveBox(
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

class ConcaveCircle extends StatelessWidget {
  const ConcaveCircle({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: InnerShadowCircle(
        direction: Alignment.topLeft,
        color: BrickColors.highlightColorLight,
        child: InnerShadowCircle(
          direction: Alignment.bottomRight,
          color: BrickColors.highlightColorDark,
          child: child,
        ),
      ),
    );
  }
}

class ConcaveBox extends StatelessWidget {
  const ConcaveBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BORDER_RADIUS_ALL_10,
      child: InnerShadowBox(
        direction: Alignment.topLeft,
        color: BrickColors.highlightColorLight,
        borderRadius: BORDER_RADIUS_ALL_10,
        //child: child,
        child: InnerShadowBox(
          direction: Alignment.bottomRight,
          color: BrickColors.highlightColorDark,
          borderRadius: BORDER_RADIUS_ALL_10,
          child: child,
        ),
      ),
    );
  }
}
