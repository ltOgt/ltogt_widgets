import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/util/single_child_scroller.dart';

class BrickFileTreeBrowser extends StatefulWidget {
  static const iconButtonPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const _borderWidth = 1.0;
  static const _guardRailWidth = 1.0;

  const BrickFileTreeBrowser({
    Key? key,
    required this.rootDir,
    this.filePathBarHeight = 30,
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
  bool showSearch = false;
  void toggleSearch() => setState(() {
        showSearch = !showSearch;
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PADDING_HORIZONTAL_40,
      child: Stack(
        children: [
          /// File List -----------------------------------
          BrickSortableList(
            sortBarTrailing: [
              BrickIconButton(
                onPressed: (_) => toggleSearch(),
                icon: Icon(Icons.search),
                size: 30,
              ),
            ],
            sortBarChildBelow: (false == showSearch)
                ? null
                : Container(
                    height: 30,
                    color: Colors.black,
                  ),
            barOnTop: true,
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
            contentPadding: EdgeInsets.only(bottom: widget.filePathBarHeight - 2),
          ),

          /// Sub-Path Info -------------------------------
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BrickSortableList.defaultBoxConstraints.copyWith(
                minHeight: widget.filePathBarHeight - 2 * BrickFileTreeBrowser._borderWidth,
                maxHeight: widget.filePathBarHeight - 2 * BrickFileTreeBrowser._borderWidth,
              ),
              height: widget.filePathBarHeight - 2 * BrickFileTreeBrowser._borderWidth,
              decoration: BoxDecoration(
                borderRadius: BORDER_RADIUS_ALL_10,
                color: BrickColors.GREY_2,
              ),
              child: Row(
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
                                        mode: (i == widget.pathIndex) ? BendMode.CONCAVE : BendMode.CONVEX,
                                        bgColor:
                                            (i == widget.pathIndex) ? BrickColors.buttonActive : BrickColors.buttonIdle,
                                      ),
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
              ),
            ),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BORDER_RADIUS_ALL_10,
      child: Material(
        color: Colors.transparent,
        child: BrickInkWell(
          color: Colors.transparent,
          onTap: (r) {},
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
