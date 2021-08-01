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
    required this.crossAxisSize,
    required this.children,
    this.leading,
    this.leadingShadow,
    this.trailing,
    this.trailingShadow,
    this.guardRail,
    this.guardRailShadow,
    this.guardRailCrossAxisSize,
    this.guardRailTwo,
    this.guardRailTwoShadow,
    this.guardRailTwoCrossAxisSize,
  }) : super(key: key);

  /// Whether to scroll [children] on [Axis.horizontal] or [Axis.vertical].
  final Axis scrollDirection;

  // TODO might one day want to expose axis/crossAxis paramters from row/column and make this nullable
  /// Optional extend for the mainAxis.
  /// To expand use `double.infinity`
  final double? mainAxisSize;

  // TODO might one day want to expose axis/crossAxis paramters from row/column and make this nullable
  /// The extend of the crossAxis.
  final double crossAxisSize;

  /// The content that is to be scrolled in [scrollDirection].
  final List<Widget> children;

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
  final Widget? guardRail;

  /// Optional shadow for [guardRail]
  /// Also possible for null [guardRail].
  final List<BoxShadow>? guardRailShadow;

  /// Extend of optional [guardRail](/[guardRailTwo])
  final double? guardRailCrossAxisSize;

  /// Optional rail to add to the cross axis end of [children].
  /// Replaces [guardRail] on that side.
  final Widget? guardRailTwo;

  /// Optional shadow for [guardRailTwo]
  /// Also possible for null [guardRailTwo].
  final List<BoxShadow>? guardRailTwoShadow;

  /// Extend of optional [guardRailTwo]
  final double? guardRailTwoCrossAxisSize;

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
        children: [
          /// {@template leadingTrailing}
          /// Shadow for [leading] and [trailing] has to be rendered via stack, so it is visible above [chilren].
          /// [leading] and [trailing] are positioned in an outer [RowOrColumn] to get the spacing for free.
          /// {@endtemplate}
          if (leading != null) leading!,

          /// ----------------------------------------------------------------------- Cross Axis Column/Row for guards
          RowOrColumn(
            axis: _crossAxis,
            children: [
              /// ------------------------------------------------------------------- [guardRail] at [_crossAxisStart]
              if (guardRail != null)
                AxisSizedBox(
                  mainAxis: scrollDirection,
                  crossAxisSize: guardRailCrossAxisSize,
                  child: guardRail!,
                ),

              /// ------------------------------------------------------------------- Stack for [children] plus [leadingShadow] and [trailingShadow]
              /// -------------------------------------------------------------------                      plus [guardRailShadow] ( and [guardRailTwoShadow])
              Stack(
                children: [
                  /// --------------------------------------------------------------- Scrollable for [children]
                  SingleChildScroller(
                    reverse: false, // TODO expose
                    scrollToEnd: true, // TODO expose
                    scrollDirection: scrollDirection,
                    child: RowOrColumn(
                      axis: scrollDirection,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  ),

                  /// --------------------------------------------------------------- Layer Above: [guardRailShadow] (and [guardRailTwoShadow])
                  /// ----------------------------------------------- [guardRailShadow]
                  if (guardRailShadow != null)
                    AlignPositioned(
                      alignment: _crossAxisStart,
                      child: ShadowBox(
                        shadow: guardRailShadow,
                        child: AxisSizedBox(
                          mainAxis: scrollDirection,
                          crossAxisSize: guardRailCrossAxisSize,
                        ),
                      ),
                    ),

                  /// ----------------------------------------------- [guardRailShadow] / [guardRailShadowTwo]
                  if ((guardRailTwoShadow != null) || (guardRailShadow != null))
                    AlignPositioned(
                      alignment: _crossAxisEnd,
                      child: ShadowBox(
                        shadow: guardRailTwoShadow ?? guardRailShadow,
                        child: AxisSizedBox(
                          mainAxis: scrollDirection,
                          crossAxisSize: guardRailTwoCrossAxisSize ?? guardRailCrossAxisSize,
                        ),
                      ),
                    ),

                  /// --------------------------------------------------------------- Layer Above: [leadingShadow] and [trailingShadow]
                  /// ----------------------------------------------- [leadingShadow]
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

                  /// ----------------------------------------------- [trailingShadow]
                  if (trailingShadow != null)
                    AlignPositioned(
                      alignment: _mainAxisEnd,
                      child: Container(
                        height: _isHorizontal ? crossAxisSize : 0,
                        width: _isHorizontal ? 0 : crossAxisSize,
                        decoration: BoxDecoration(
                          //color: Colors.black, // TODO is the needed?
                          boxShadow: leadingShadow,
                        ),
                      ),
                    ),
                ],
              ),

              /// ------------------------------------------------------------------- [guardRail] / [guardRailTwo] at [_crossAxisEnd]
              if (guardRailTwo != null || guardRail != null)
                AxisSizedBox(
                  mainAxis: scrollDirection,
                  crossAxisSize: guardRailCrossAxisSize,
                  child: guardRailTwo ?? guardRail!,
                ),
            ],
          ),

          /// {@macro leadingTrailing}
          if (trailing != null) trailing!,
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.filePathBarHeight,
          child: BrickButton(
            borderRadius: BrickButton.defaultBorderRadius.copyWith(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            onPress: () {},
            padding: BrickFileTreeBrowser.iconButtonPadding,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                Icons.home,
              ),
            ),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _FilePathGuardRail(),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SingleChildScroller(
                      reverse: false,
                      scrollToEnd: true,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: widget.filePathBarHeight -
                            2 * BrickFileTreeBrowser._borderWidth -
                            2 * _FilePathGuardRail.totalWidth,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: ListGenerator.forEach(
                            list: widget.path.path,
                            builder: (String segment, int i) => BrickButton(
                                // Add border only to right, otherwise always 2 pixel border (1 of each neighbour)
                                // Also enables to have single pixel border along whole guardRail
                                border: const Border(
                                  right: BorderSide(color: BrickColors.borderDark, width: 1),
                                ),
                                borderRadius: null,
                                child: ConditionalParentWidget(
                                  condition: widget.filePathBarHeight < 30,
                                  parentBuilder: (child) => FittedBox(
                                    child: child,
                                  ),
                                  child: Center(
                                    child: Text(
                                      segment,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                // child: FittedBox(
                                //   fit: BoxFit.contain,
                                //   alignment: Alignment.center,
                                //   child: Text(segment),
                                // ),

                                padding: PADDING_HORIZONTAL_5,
                                onPress: () {},
                                isActive: i == widget.pathIndex),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: widget.filePathBarHeight,
                      width: 0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(-1, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      height: widget.filePathBarHeight,
                      width: 0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(1, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const _FilePathGuardRail(),
            ],
          ),
        ),
        SizedBox(
          height: widget.filePathBarHeight,
          child: BrickButton(
            borderRadius: BrickButton.defaultBorderRadius.copyWith(
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ),
            onPress: () {},
            padding: BrickFileTreeBrowser.iconButtonPadding,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
