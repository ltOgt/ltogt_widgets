import 'package:flutter/widgets.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/src/style/brick_theme_provider.dart';

class MatchText extends StatelessWidget {
  const MatchText({
    Key? key,
    required this.text,
    required this.match,
    this.fontSize,
  }) : super(key: key);

  final String text;
  final StringOffset match;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    final segments = StringHelper.splitStringBasedOnMatch(text, match);

    return RichText(
      text: TextSpan(
        children: [
          // pre-match
          TextSpan(
            text: segments[0],
            style: TextStyle(
              color: theme.color.text,
              fontSize: fontSize,
            ),
          ),
          // match
          TextSpan(
            text: segments[1],
            style: TextStyle(
              backgroundColor: theme.color.textMatchBg,
              color: theme.color.textMatchFg,
              fontSize: fontSize,
            ),
          ),
          // post-match
          TextSpan(
            text: segments[2],
            style: TextStyle(
              color: theme.color.text,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
