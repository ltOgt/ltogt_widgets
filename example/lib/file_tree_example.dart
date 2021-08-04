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
                  initialPath: FileTreePath([rootDir.name]),
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
  name: "home",
  dirs: [
    FileTreeDir(
      name: "user",
      dirs: [
        FileTreeDir(
          name: "documents",
          files: [
            FileTreeFile(name: "homework.tex"),
            FileTreeFile(name: "homework.pdf"),
          ],
        ),
        FileTreeDir(name: "pictures", files: [
          FileTreeFile(name: "doggo.jpg"),
          FileTreeFile(name: "doggo2.jpg"),
          FileTreeFile(name: "doggo3.jpg"),
          FileTreeFile(name: "doggo4.jpg"),
          FileTreeFile(name: "doggo5.jpg"),
          FileTreeFile(name: "doggo_hd.png"),
          FileTreeFile(name: "kitty.jpg"),
          FileTreeFile(name: "kitty2.jpg"),
          FileTreeFile(name: "kitty3.jpg"),
          FileTreeFile(name: "kitty4.jpg"),
          FileTreeFile(name: "kitty5.jpg"),
          FileTreeFile(name: "kitty_hd.png"),
        ]),
        FileTreeDir(
          name: "downloads",
        ),
      ],
    ),
  ],
);
