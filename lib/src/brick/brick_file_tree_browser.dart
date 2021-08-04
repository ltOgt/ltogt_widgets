import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/brick/brick_icon.dart';
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
    this.onSelect,
    this.onOpen,
  }) : super(key: key);

  final double filePathBarHeight;

  final FileTreeDir rootDir;
  final FileTreePath initialPath;

  /// Called when a file or directory has be clicked once.
  /// The respective entity will be highlighted in the list.
  /// This callbacks enables e.g. to pick a file or directory via single click.
  final Function(FileTreeEntity file, FileTreePath path)? onSelect;
  // TODO might need list for multi select
  // TODO should FileTreeEntities know their own path

  /// Called when a file or directory has be clicked twice.
  /// The respective entity will be highlighted in the list.
  /// If the entity is a directory, it will be entered instead.
  /// This callbacks enables e.g. to pick a file or dir via double click.
  final Function(FileTreeEntity file, FileTreePath path)? onOpen;

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
  late List<FileTreeEntity> sCurrentDirContent = widget.rootDir.entities;

  late FileTreePath sCurrentPath = widget.initialPath;
  late int sCurrentPathIndex = sCurrentPath.segments.length - 1;

  // TODO ? reset on search change
  FileTreeEntity? sSelectedFile;

  void onSelectFile(FileTreeEntity file) {
    if (file != sSelectedFile) {
      setState(() {
        sSelectedFile = file;
      });
      // TODO needs to resepect current index too
      widget.onSelect?.call(file, sCurrentPath);
    } else {
      // TODO needs to resepect current index too
      widget.onOpen?.call(file, sCurrentPath);
      openIfDir(file);
    }
  }

  void openIfDir(FileTreeEntity e) {
    if (e.isDir) {
      setState(() {
        sCurrentDirContent = (e as FileTreeDir).entities;
        sCurrentPath = FileTreePath([
          ...sCurrentPath.segments.sublist(0, sCurrentPathIndex + 1),
          e.name,
        ]);
        sCurrentPathIndex += 1;
      });
    }
  }

  void onSelectPathSegment(int segmentIndex) {
    var dir = widget.rootDir;
    for (int s = 1; s <= segmentIndex; s++) {
      dir = dir.dirs.firstWhere((element) => element.name == sCurrentPath.segments[s]);
    }

    setState(() {
      sCurrentPathIndex = segmentIndex;
      sCurrentDirContent = dir.entities;
    });
  }

  static const _homeIcon = BrickIcon(
    Icons.home,
  );
  static const _backIcon = BrickIcon(
    Icons.arrow_back,
  );

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);
    final _shadowColor = theme.color.shadow;

    return BrickInteractiveList(
      isSearchEnabled: true,
      isSortEnabled: true,

      /// ------------------------------------------------- files to be displayed and sorted for current level
      childData: sCurrentDirContent
          .map((fileInCurrentDir) => ChildDataBIL(
                data: fileInCurrentDir,
                build: (c, matches) => FileTreeNodeWidget(
                  fileTreeEntity: fileInCurrentDir,
                  matches: matches,
                  isSelected: fileInCurrentDir == sSelectedFile,
                  onSelect: () => onSelectFile(fileInCurrentDir),
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
            // TODO on change of path, the scrollable should always be rebuild to again scroll to the right
            homeIcon: _homeIcon,
            backIcon: _backIcon,
            shadowColor: _shadowColor,
            borderColor: theme.color.borderDark,
            activePathIndex: sCurrentPathIndex,
            height: widget.filePathBarHeight,
            pathSegments: sCurrentPath.segments,
            onPressPathSegment: onSelectPathSegment,
            onPressHome: () => onSelectPathSegment(0),
            onPressBack: () => onSelectPathSegment(max(0, sCurrentPathIndex - 1)),
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

  final BrickIcon homeIcon;
  final BrickIcon backIcon;
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
    required this.onSelect,
    required this.isSelected,
  }) : super(key: key);

  final FileTreeEntity fileTreeEntity;
  final StringOffsetByParameterName? matches;

  final Function() onSelect;
  final bool isSelected;

  bool get isDir => fileTreeEntity.isDir;
  List<FileTreeEntity> get children => (fileTreeEntity as FileTreeDir).entities;

  static const fileIconDocument = BrickIcon(Icons.description);
  static const fileIconImage = BrickIcon(Icons.image);
  static const fileIconVideo = BrickIcon(Icons.movie);
  static const fileIconAudio = BrickIcon(Icons.audiotrack);

  // TODO add more
  BrickIcon get iconForFileType {
    final String _type = FileHelper.fileType(fileTreeEntity.name).toLowerCase();
    switch (_type) {
      case '.png':
      case '.jpg':
      case '.jpeg':
        return fileIconImage;
      case '.mp4':
      case '.mov':
      case '.avi':
      case '.flv':
      case '.mpg':
        return fileIconVideo;
      case '.mp3':
      case '.wav':
        return fileIconAudio;
      default:
        return fileIconDocument;
    }
  }

  @override
  Widget build(BuildContext context) {
    String _fileName = fileTreeEntity.name;

    StringOffset? _nameMatch = matches?[BrickFileTreeBrowser.namePARAM.name];

    final theme = BrickThemeProvider.getTheme(context);
    final color = theme.color;

    final _bgColor = isSelected ? color.hover : Colors.transparent;

    return ClipRRect(
      borderRadius: BORDER_RADIUS_ALL_10,
      child: BrickInkWell(
        color: _bgColor,
        onTap: (_) => onSelect(),
        child: Padding(
          padding: PADDING_ALL_5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isDir) ...[
                const BrickIcon(Icons.folder),
              ] else ...[
                iconForFileType,
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
    );
  }
}
