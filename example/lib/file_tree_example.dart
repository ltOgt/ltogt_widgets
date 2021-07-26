import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Brick Button Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: BrickFileTreeBrowser(
            rootDir: rootDir,
            pathIndex: 3,
            path: FileTreePath([
              "this",
              "is",
              "the",
              //
              "path", "which", "is", "actually", "waaaaay", "waay", "to", "long",
              "path", "which", "is", "actually", "waaaaay", "waay", "to", "long",
              "path", "which", "is", "actually", "waaaaay", "waay", "to", "long",
            ]),
          ),
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
    FileTreeFile(name: "file1.txt"),
    FileTreeFile(name: "file2.txt"),
    FileTreeFile(name: "file3.txt"),
    FileTreeFile(name: "file4.txt"),
    FileTreeFile(name: "file5.txt"),
    FileTreeFile(name: "file6.txt"),
    FileTreeFile(name: "file7.txt"),
    FileTreeFile(name: "file8.txt"),
    FileTreeFile(name: "file9.txt"),
    FileTreeFile(name: "file1.txt"),
    FileTreeFile(name: "file2.txt"),
    FileTreeFile(name: "file3.txt"),
    FileTreeFile(name: "file4.txt"),
    FileTreeFile(name: "file5.txt"),
    FileTreeFile(name: "file6.txt"),
    FileTreeFile(name: "file7.txt"),
    FileTreeFile(name: "file8.txt"),
    FileTreeFile(name: "file9.txt"),
  ],
);
