import 'package:flutter/widgets.dart';
import 'package:ltogt_widgets/src/style/brick_theme.dart';

class BrickThemeProvider extends InheritedWidget {
  final BrickTheme theme;

  const BrickThemeProvider({
    Key? key,
    required Widget child,
    required this.theme,
  }) : super(key: key, child: child);

  static BrickThemeProvider adjustLocal({
    required Widget child,
    required BuildContext context,
    required BrickTheme Function(BrickTheme theme) changeExisting,
  }) {
    final changedTheme = changeExisting(BrickThemeProvider.getTheme(context));

    return BrickThemeProvider(
      child: child,
      theme: changedTheme,
    );
  }

  static BrickThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BrickThemeProvider>();
  }

  /// Looks up BrickThemeProvider in the tree (see [BrickThemeProvider.of]) and gets its [theme]
  /// Defaults to [BrickTheme.defaultTheme]
  static BrickTheme getTheme(BuildContext context) {
    final fromTree = BrickThemeProvider.of(context)?.theme;

    // assert(() {
    //   print("[BrickThemeProvider.getTheme] did not find [BrickTheme]. Falling back on [BrickTheme.defaultTheme].");
    //   return true;
    // }());

    return fromTree ?? BrickTheme.defaultTheme;
  }

  @override
  bool updateShouldNotify(BrickThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
