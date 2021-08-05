import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Brick File Tree Browser Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("File Tree Browser Example"),
            BrickIconButton(icon: Icon(Icons.home)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              height: 800,
              child: BrickFileTreeBrowser(
                rootDir: rootDir,
                initialPath: FileTreePath([rootDir.name]),
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
  files: [
    FileTreeFile(
      name: "some_very_long_file_name_to_see_how_those_are_handled_when_they_are_longer_than_the_screen_is_widge.txt",
      lastChange: DateTime.now(),
    ),
  ],
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
