import 'package:flutter/widgets.dart';
import 'package:ltogt_widgets/src/style/brick_theme_provider.dart';

class BrickIcon extends StatelessWidget {
  const BrickIcon(this.iconData, {Key? key}) : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    return Icon(
      iconData,
      color: theme.color.icon,
    );
  }
}
