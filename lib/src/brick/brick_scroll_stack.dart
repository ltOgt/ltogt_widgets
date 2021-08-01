import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/src/util/align_positioned.dart';
import 'package:ltogt_widgets/src/util/axis_sized_box.dart';
import 'package:ltogt_widgets/src/util/shadow_box.dart';
import 'package:ltogt_widgets/src/util/single_child_scroller.dart';

class BrickScrollStack extends StatelessWidget {
  const BrickScrollStack({
    Key? key,
    required this.scrollDirection,
    this.mainAxisSize,
    this.crossAxisSize,
    required this.children,
    this.childPadding = EdgeInsets.zero,
    this.leading,
    this.leadingShadow,
    this.trailing,
    this.trailingShadow,
    this.leadingCross,
    this.leadingCrossShadow,
    this.leadingCrossExtend,
    this.trailingCross,
    this.trailingCrossShadow,
    this.trailingCrossExtend,
    this.scrollToEnd = false,
  }) : super(key: key);

  /// Whether to scroll [children] on [Axis.horizontal] or [Axis.vertical].
  final Axis scrollDirection;

  // TODO might one day want to expose axis/crossAxis paramters from row/column and make this nullable
  /// Optional extend for the mainAxis.
  /// To expand use `double.infinity`
  final double? mainAxisSize;

  // TODO might one day want to expose axis/crossAxis paramters from row/column and make this nullable
  /// The extend of the crossAxis.
  final double? crossAxisSize;

  /// The content that is to be scrolled in [scrollDirection].
  final List<Widget> children;

  /// Additional padding to the scroll area around [children].
  final EdgeInsetsGeometry childPadding;

  /// Optional Widget that leads [children].
  final Widget? leading;

  /// Optional shadow for [leading].
  /// Also possible for null [leading].
  final List<BoxShadow>? leadingShadow;

  /// Optional Widget that trails [children].
  final Widget? trailing;

  /// Optional shadow for [trailing].
  /// Also possible for null [trailing].
  final List<BoxShadow>? trailingShadow;

  /// Optional rail to surround [children] on the cross axis with.
  final Widget? leadingCross;

  /// Optional shadow for [leadingCross]
  /// Also possible for null [leadingCross].
  final List<BoxShadow>? leadingCrossShadow;

  /// Extend of optional [leadingCross]
  final double? leadingCrossExtend; // TODO remove

  /// Optional rail to add to the cross axis end of [children].
  final Widget? trailingCross;

  /// Optional shadow for [trailingCross]
  /// Also possible for null [trailingCross].
  final List<BoxShadow>? trailingCrossShadow;

  /// Extend of optional [trailingCross]
  final double? trailingCrossExtend; // TODO remove

  /// {@marco scrollToEnd}
  final bool scrollToEnd;

  bool get _isHorizontal => scrollDirection == Axis.horizontal;
  Axis get _crossAxis => _isHorizontal ? Axis.vertical : Axis.horizontal;
  Alignment get _mainAxisStart => _isHorizontal ? Alignment.centerLeft : Alignment.topCenter;
  Alignment get _mainAxisEnd => _isHorizontal ? Alignment.centerRight : Alignment.bottomCenter;
  Alignment get _crossAxisStart => _isHorizontal ? Alignment.topCenter : Alignment.centerLeft;
  Alignment get _crossAxisEnd => _isHorizontal ? Alignment.bottomCenter : Alignment.centerRight;

  @override
  Widget build(BuildContext context) {
    return AxisSizedBox(
      mainAxis: scrollDirection,
      mainAxisSize: mainAxisSize,
      crossAxisSize: crossAxisSize,

      /// --------------------------------------------------------------------------- Outer Row/Column for [leading] and [trailing]
      child: RowOrColumn(
        axis: scrollDirection,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// {@template leadingTrailing}
          /// Shadow for [leading] and [trailing] has to be rendered via stack, so it is visible above [chilren].
          /// [leading] and [trailing] are positioned in an outer [RowOrColumn] to get the spacing for free.
          /// {@endtemplate}
          if (leading != null) leading!,

          /// ----------------------------------------------------------------------- Cross Axis Column/Row for guards
          Flexible(
            child: RowOrColumn(
              axis: _crossAxis,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              leading: (leadingCross == null)
                  ? null
                  : AxisSizedBox(
                      mainAxis: scrollDirection,
                      crossAxisSize: leadingCrossExtend,
                      child: leadingCross!,
                    ),
              trailing: (trailingCross == null)
                  ? null
                  : AxisSizedBox(
                      mainAxis: scrollDirection,
                      crossAxisSize: leadingCrossExtend,
                      child: trailingCross,
                    ),

              /// --------------------------------------------------------------------- Stack for [children] plus [leadingShadow] and [trailingShadow]
              /// ---------------------------------------------------------------------                      plus [leadingCrossShadow] ( and [guardRailTwoShadow])
              child: Expanded(
                /// : Clip Shadows
                child: ClipRect(
                  child: Stack(
                    children: [
                      /// ----------------------------------------------------------------- Scrollable for [children]
                      AxisSizedBox(
                        mainAxis: scrollDirection,
                        mainAxisSize: double.infinity,
                        child: Padding(
                          padding: childPadding,
                          child: SingleChildScroller(
                            reverse: false, // TODO expose
                            scrollToEnd: scrollToEnd,
                            scrollDirection: scrollDirection,
                            child: RowOrColumn(
                              axis: scrollDirection,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: children,
                            ),
                          ),
                        ),
                      ),

                      /// ----------------------------------------------------------------- Layer Above: [leadingCrossShadow] (and [trailingCrossShadow])
                      /// ------------------------------------------------- [leadingCrossShadow]
                      if (leadingCrossShadow != null)
                        AlignPositioned(
                          alignment: _crossAxisStart,
                          child: ShadowBox(
                            shadow: leadingCrossShadow,
                            child: AxisSizedBox(
                              mainAxis: scrollDirection,
                              crossAxisSize: leadingCrossExtend,
                            ),
                          ),
                        ),

                      /// ------------------------------------------------- [leadingCrossShadow] / [trailingCrossShadow]
                      if (trailingCrossShadow != null)
                        AlignPositioned(
                          alignment: _crossAxisEnd,
                          child: ShadowBox(
                            shadow: trailingCrossShadow,
                            child: AxisSizedBox(
                              mainAxis: scrollDirection,
                              crossAxisSize: trailingCrossExtend,
                            ),
                          ),
                        ),

                      /// ----------------------------------------------------------------- Layer Above: [leadingShadow] and [trailingShadow]
                      /// ------------------------------------------------- [leadingShadow]
                      if (leadingShadow != null)
                        AlignPositioned(
                          alignment: _mainAxisStart,
                          child: Container(
                            height: _isHorizontal ? crossAxisSize : 0,
                            width: _isHorizontal ? 0 : crossAxisSize,
                            decoration: BoxDecoration(
                              //color: Colors.black, // TODO is the needed?
                              boxShadow: leadingShadow,
                            ),
                          ),
                        ),

                      /// ------------------------------------------------- [trailingShadow]
                      if (trailingShadow != null)
                        AlignPositioned(
                          alignment: _mainAxisEnd,
                          child: Container(
                            height: _isHorizontal ? crossAxisSize : 0,
                            width: _isHorizontal ? 0 : crossAxisSize,
                            decoration: BoxDecoration(
                              //color: Colors.black, // TODO is the needed?
                              boxShadow: trailingShadow,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// {@macro leadingTrailing}
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
