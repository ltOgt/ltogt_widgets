import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_child_data.dart';
import 'package:ltogt_widgets/src/brick/interactive_list/bil_search_matches.dart';
import 'package:ltogt_widgets/src/util/match_text.dart';

class BrickFileTreeBrowser extends StatefulWidget {
  static const iconButtonPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const _borderWidth = 1.0;

  const BrickFileTreeBrowser({
    Key? key,
    required this.rootDir,
    this.filePathBarHeight = 28,
    required this.initialPath,
  }) : super(key: key);

  final double filePathBarHeight;

  final FileTreeDir rootDir;
  final FileTreePath initialPath;

  @override
  State<BrickFileTreeBrowser> createState() => _BrickFileTreeBrowserState();

  // ================================================================== INTERACTIVE LIST CONSTS
  static int compareName(FileTreeEntity f1, FileTreeEntity f2) =>
      f1.name.toLowerCase().compareTo(f2.name.toLowerCase());
  static int compareChange(FileTreeEntity f1, FileTreeEntity f2) =>
      (f1.lastChange == null) ? -1 : (f2.lastChange == null ? 1 : f1.lastChange!.compareTo(f2.lastChange!));
  static String extractNameForSearch(FileTreeEntity e) => e.name;

  static const namePARAM = ParameterBIL(
    name: "Name",
    sort: compareName,
    searchStringExtractor: extractNameForSearch,
  );
  static const changePARAM = ParameterBIL(
    name: "Change",
    sort: BrickFileTreeBrowser.compareChange,
  );
}

class _BrickFileTreeBrowserState extends State<BrickFileTreeBrowser> {
  // TODO make changeable
  late List<FileTreeEntity> currentDirContent = widget.rootDir.entities;

  late FileTreePath currentPath = widget.initialPath;
  late int currentPathIndex = currentPath.segments.length - 1;

  // TODO reset on search change
  int? selectedFileIndex;

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    final _iconColor = theme.color.icon;
    final _shadowColor = theme.color.shadow;

    final _homeIcon = Icon(Icons.home, color: _iconColor);
    final _backIcon = Icon(Icons.arrow_back, color: _iconColor);

    return BrickInteractiveList(
      isSearchEnabled: true,
      isSortEnabled: true,

      /// ------------------------------------------------- files to be displayed and sorted for current level
      childData: currentDirContent
          .map((fileInCurrentDir) => ChildDataBIL(
                data: fileInCurrentDir,
                build: (c, matches) => FileTreeNodeWidget(
                  fileTreeEntity: fileInCurrentDir,
                  matches: matches,
                ),
              ))
          .toList(),

      /// ------------------------------------------------- keys to sort [childData] by
      childDataParameters: const [
        BrickFileTreeBrowser.namePARAM,
        BrickFileTreeBrowser.changePARAM,
      ],

      /// ------------------------------------------------- [padding] for overlay
      additionalContentPadding: EdgeInsets.only(bottom: widget.filePathBarHeight - 2),

      /// ------------------------------------------------- file path overlay
      overlay: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _FilePathOverlay(
            homeIcon: _homeIcon,
            backIcon: _backIcon,
            shadowColor: _shadowColor,
            borderColor: theme.color.borderDark,
            activePathIndex: currentPathIndex,
            height: widget.filePathBarHeight,
            pathSegments: currentPath.segments,
            onPressPathSegment: (i) => setState(() {
              currentPathIndex = i;
            }),
            onPressHome: () => setState(() {
              currentPathIndex = 0;
            }),
            onPressBack: () => setState(() {
              currentPathIndex = max(0, currentPathIndex - 1);
            }),
          ),
        ),
      ],
    );
  }
}

class _FilePathOverlay extends StatelessWidget {
  const _FilePathOverlay({
    Key? key,
    required this.homeIcon,
    required this.backIcon,
    required this.shadowColor,
    required this.borderColor,
    required this.height,
    required this.activePathIndex,
    required this.pathSegments,
    required this.onPressPathSegment,
    required this.onPressHome,
    required this.onPressBack,
  }) : super(key: key);

  final Icon homeIcon;
  final Icon backIcon;
  final Color shadowColor;
  final Color borderColor;

  final int activePathIndex;
  final double height;
  final List<String> pathSegments;

  final Function(int i) onPressPathSegment;
  final Function() onPressHome;
  final Function() onPressBack;

  @override
  Widget build(BuildContext context) {
    return BrickScrollStack(
      scrollToEnd: true,
      scrollDirection: Axis.horizontal,
      crossAxisSize: height,
      leading: BrickButton(
        borderRadius: BrickButton.defaultBorderRadius.copyWith(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        onPress: onPressHome,
        padding: BrickFileTreeBrowser.iconButtonPadding,
        child: FittedBox(
          fit: BoxFit.contain,
          child: homeIcon,
        ),
      ),
      trailing: BrickButton(
        borderRadius: BrickButton.defaultBorderRadius.copyWith(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
        onPress: onPressBack,
        padding: BrickFileTreeBrowser.iconButtonPadding,
        child: FittedBox(
          fit: BoxFit.contain,
          child: backIcon,
        ),
      ),
      leadingShadow: [
        BoxShadow(
          color: shadowColor,
          blurRadius: 5,
          spreadRadius: 2,
          offset: const Offset(-1, 0),
        ),
      ],
      trailingShadow: [
        BoxShadow(
          color: shadowColor,
          blurRadius: 5,
          spreadRadius: 2,
          offset: const Offset(1, 0),
        ),
      ],
      leadingCross: const _FilePathGuardRail(),
      trailingCross: const _FilePathGuardRail(),
      children: ListGenerator.forEach(
        list: pathSegments,
        builder: (String segment, int i) => BrickButton(
          // Add border only to right, otherwise always 2 pixel border (1 of each neighbour)
          // Also enables to have single pixel border along whole guardRail
          border: Border(
            right: BorderSide(color: borderColor, width: 1),
          ),
          borderRadius: null,
          child: ConditionalParentWidget(
            condition: height < 30,
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
          padding: PADDING_HORIZONTAL_5,
          onPress: () => onPressPathSegment(i),
          isActive: i == activePathIndex,
        ),
      ),
    );
  }
}

class _FilePathGuardRail extends StatelessWidget {
  const _FilePathGuardRail({
    Key? key,
  }) : super(key: key);

  static const double width = 1;
  static const double borderWidth = 1;
  static const double totalWidth = width + 2 * borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    final _border = BorderSide(
      color: theme.color.borderDark,
      width: BrickFileTreeBrowser._borderWidth,
    );

    return Container(
      height: totalWidth,
      decoration: BoxDecoration(
        color: theme.color.buttonIdle,
        border: Border(
          bottom: _border,
          top: _border,
        ),
      ),
    );
  }
}

class FileTreeNodeWidget extends StatelessWidget {
  const FileTreeNodeWidget({
    Key? key,
    required this.fileTreeEntity,
    this.matches,
  }) : super(key: key);

  final FileTreeEntity fileTreeEntity;
  final StringOffsetByParameterName? matches;

  bool get isDir => fileTreeEntity.isDir;
  List<FileTreeEntity> get children => (fileTreeEntity as FileTreeDir).entities;

  handleTap(Rect? rect) {}

  @override
  Widget build(BuildContext context) {
    String _fileName = fileTreeEntity.name;

    StringOffset? _nameMatch = matches?[BrickFileTreeBrowser.namePARAM.name];

    return ClipRRect(
      borderRadius: BORDER_RADIUS_ALL_10,
      child: Material(
        color: Colors.transparent,
        child: BrickInkWell(
          color: Colors.transparent,
          onTap: handleTap,
          child: Padding(
            padding: PADDING_ALL_5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isDir) ...[
                  const Icon(Icons.folder),
                ] else ...[
                  // keep same space for files
                  const Icon(Icons.description),
                ],
                SIZED_BOX_5,
                ConditionalParentWidget(
                  condition: fileTreeEntity.lastChange != null,
                  parentBuilder: (child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      child,
                      SIZED_BOX_2,
                      Text(
                        DateHelper.dateString(fileTreeEntity.lastChange!),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  child: (_nameMatch == null) //
                      ? Text(_fileName)
                      : MatchText(text: _fileName, match: _nameMatch),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
