import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/const/sizes.dart';
import 'package:ltogt_widgets/src/util/single_child_scroller.dart';

class BrickFileTreeBrowser extends StatefulWidget {
  static const iconButtonPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const _borderWidth = 1.0;
  static const _guardRailWidth = 1.0;

  const BrickFileTreeBrowser({
    Key? key,
    required this.rootDir,
    this.filePathBarHeight = 28,
    required this.path,
    required this.pathIndex,
  }) : super(key: key);

  final double filePathBarHeight;

  final FileTreeDir rootDir;
  final FileTreePath path;
  final int pathIndex;

  static int compareName(FileTreeEntity f1, FileTreeEntity f2) =>
      f1.name.toLowerCase().compareTo(f2.name.toLowerCase());
  static int compareChange(FileTreeEntity f1, FileTreeEntity f2) =>
      (f1.lastChange == null) ? -1 : (f2.lastChange == null ? 1 : f1.lastChange!.compareTo(f2.lastChange!));

  @override
  State<BrickFileTreeBrowser> createState() => _BrickFileTreeBrowserState();
}

class _BrickFileTreeBrowserState extends State<BrickFileTreeBrowser> {
  static const _searchIcon = Icon(Icons.search, color: BrickColors.iconColor);

  bool showSearch = false;
  void toggleSearch() => setState(() {
        showSearch = !showSearch;
      });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// File List -----------------------------------
        Positioned.fill(
          child: BrickSortableList(
            sortBarTrailing: [
              BrickIconButton(
                // TODO add isActive flag to buttons that make green and concave (also assert that no custom mode + color passed in that case)
                color: showSearch ? BrickColors.buttonActive : BrickColors.buttonIdle,
                mode: showSearch ? BendMode.CONCAVE : BendMode.CONVEX,
                onPressed: (_) => toggleSearch(),
                icon: _searchIcon,
                size: SMALL_BUTTON_SIZE,
              ),
            ],
            sortBarChildBelow: (false == showSearch)
                ? null
                : Container(
                    // TODO search bar
                    height: 30,
                    color: Colors.black,
                  ),
            childData: widget.rootDir.entities
                .map((fileUnderRoot) => ChildData(
                      data: fileUnderRoot,
                      build: (c) => FileTreeNodeWidget(
                        fileTreeEntity: fileUnderRoot,
                      ),
                    ))
                .toList(),
            sortingOptions: const [
              SortingOption(name: "Name", compare: BrickFileTreeBrowser.compareName),
              SortingOption(name: "Change", compare: BrickFileTreeBrowser.compareChange),
            ],
            additionalContentPadding: EdgeInsets.only(bottom: widget.filePathBarHeight - 2),
          ),
        ),

        /// Sub-Path Info -------------------------------
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BrickScrollStack(
            scrollDirection: Axis.horizontal,
            crossAxisSize: widget.filePathBarHeight,
            leading: BrickButton(
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
            trailing: BrickButton(
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
            leadingShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(-1, 0),
              ),
            ],
            trailingShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(1, 0),
              ),
            ],
            leadingCross: const _FilePathGuardRail(),
            trailingCross: const _FilePathGuardRail(),
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
                padding: PADDING_HORIZONTAL_5,
                onPress: () {},
                isActive: i == widget.pathIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilePathGuardRail extends StatelessWidget {
  const _FilePathGuardRail({
    Key? key,
  }) : super(key: key);

  static const border = BorderSide(color: BrickColors.borderDark, width: BrickFileTreeBrowser._borderWidth);
  static const double width = 1;
  static const double borderWidth = 1;
  static const double totalWidth = width + 2 * borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: totalWidth,
      decoration: const BoxDecoration(
        color: BrickColors.buttonIdle,
        border: Border(
          bottom: border,
          top: border,
        ),
      ),
    );
  }
}

class FileTreeNodeWidget extends StatefulWidget {
  const FileTreeNodeWidget({
    Key? key,
    required this.fileTreeEntity,
  }) : super(key: key);

  final FileTreeEntity fileTreeEntity;

  @override
  State<FileTreeNodeWidget> createState() => _FileTreeNodeWidgetState();
}

class _FileTreeNodeWidgetState extends State<FileTreeNodeWidget> {
  bool get isDir => widget.fileTreeEntity.isDir;
  List<FileTreeEntity> get children => (widget.fileTreeEntity as FileTreeDir).entities;

  handleTap(Rect? rect) {}

  @override
  Widget build(BuildContext context) {
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
                  condition: widget.fileTreeEntity.lastChange != null,
                  parentBuilder: (child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      child,
                      SIZED_BOX_2,
                      Text(
                        DateHelper.dateString(widget.fileTreeEntity.lastChange!),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  child: Text(widget.fileTreeEntity.name),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
