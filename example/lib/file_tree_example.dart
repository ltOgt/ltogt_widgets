import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Brick Button Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(50),
                height: 500,
                child: BrickFileTreeBrowser(
                  rootDir: rootDir,
                  initialPath: FileTreePath("home/omni/repos/package/ltogt_widgets".split("/")),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

final FileTreeDir rootDir = FileTreeDir(
  name: "root",
  dirs: [
    FileTreeDir(
      name: "folder",
      dirs: [
        FileTreeDir(
          name: "folder",
        ),
      ],
      files: [
        FileTreeFile(name: "file1.txt"),
        FileTreeFile(name: "file2.txt"),
        FileTreeFile(name: "file3.txt"),
        FileTreeFile(name: "file4.txt"),
        FileTreeFile(name: "file5.txt"),
      ],
    ),
    FileTreeDir(
      name: "folderEmpty",
    ),
  ],
  files: [
    FileTreeFile(name: "file1.txt"),
    FileTreeFile(name: "file2.txt"),
    FileTreeFile(name: "file3.txt"),
    FileTreeFile(name: "file4.txt"),
    FileTreeFile(name: "file5.txt"),
    FileTreeFile(name: "file6.txt"),
    FileTreeFile(name: "file7.txt"),
    FileTreeFile(name: "file8.txt"),
    FileTreeFile(name: "file9.txt"),
    FileTreeFile(name: "file1.gid"),
    FileTreeFile(name: "file2.gid"),
    FileTreeFile(name: "file3.gid"),
    FileTreeFile(name: "file4.gid"),
    FileTreeFile(name: "file5.gid"),
    FileTreeFile(name: "file6.gid"),
    FileTreeFile(name: "file7.gid"),
    FileTreeFile(name: "file8.gid"),
    FileTreeFile(name: "file9.gid"),
  ],
);
