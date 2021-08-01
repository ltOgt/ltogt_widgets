import 'package:flutter/widgets.dart';

class ShadowBox extends StatelessWidget {
  const ShadowBox({
    Key? key,
    required this.shadow,
    required this.child,
  }) : super(key: key);

  final List<BoxShadow>? shadow;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (child == null) return const SizedBox();
    if (shadow == null) return child!;

    return DecoratedBox(
      child: child!,
      decoration: BoxDecoration(
        boxShadow: shadow!,
      ),
    );
  }
}
