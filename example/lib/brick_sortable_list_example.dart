import 'package:flutter/material.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Brick Button Example',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(
          child: TodoWidget(),
        ),
      ),
    ),
  );
}

class TodoWidget extends StatefulWidget {
  const TodoWidget({Key? key}) : super(key: key);

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  List<TodoObject> todos = [
    TodoObject(isDone: false, taskName: "Bring Out Trash", userName: "Peter"),
    TodoObject(isDone: false, taskName: "Buy Milk", userName: "Günther"),
    TodoObject(isDone: false, taskName: "Feed Cat", userName: "Peter"),
    TodoObject(isDone: false, taskName: "FEEd Cat", userName: "Peter"),
    TodoObject(isDone: false, taskName: "FEEED Cat", userName: "Peter"),
    TodoObject(isDone: false, taskName: "FEEEEED CAAT", userName: "Peter"),
  ];

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BrickSortableList(
      childData: todos
          .map((e) => ChildData<TodoObject>(
                data: e,
                build: (c) => e.build(c, update),
              ))
          .toList(),
      sortingOptions: const [
        SortingOption<TodoObject>(name: "TASK", compare: TodoObject.compareTask),
        SortingOption<TodoObject>(name: "USER", compare: TodoObject.compareUser),
        SortingOption<TodoObject>(name: "CREATE", compare: TodoObject.compareCreate),
        SortingOption<TodoObject>(name: "CHANGE", compare: TodoObject.compareChange),
        SortingOption<TodoObject>(name: "DONE", compare: TodoObject.compareDone),
      ],
      trailing: [
        const BrickIconButton(
          icon: Icon(Icons.refresh),
        ),
        SIZED_BOX_5,
        BrickIconButton(
          onPressed: (_) {},
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class TodoObject {
  final String taskName;
  final String userName;
  final DateTime creationDate;
  DateTime? _changeDate;
  DateTime get changeDate => _changeDate ?? creationDate;
  bool isDone;

  TodoObject({
    required this.taskName,
    required this.userName,
    required this.isDone,
  })  : creationDate = DateTime.now(),
        _changeDate = null;

  Widget build(BuildContext context, [Function()? setState]) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
                value: isDone,
                onChanged: (v) {
                  isDone = v!;
                  _changeDate = DateTime.now();
                  setState?.call();
                }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TASK: $taskName"),
                Text("USER: $userName"),
                Text("CREATED: $creationDate"),
                Text("CHANGED: $changeDate"),
              ],
            ),
          ],
        ),
      );

  static int compareDone(TodoObject t1, TodoObject t2) => (t2.isDone == t1.isDone) ? 0 : (t2.isDone ? 1 : -1);
  static int compareTask(TodoObject t1, TodoObject t2) => t1.taskName.compareTo(t2.taskName);
  static int compareUser(TodoObject t1, TodoObject t2) => t1.userName.compareTo(t2.userName);
  static int compareCreate(TodoObject t1, TodoObject t2) => t1.creationDate.compareTo(t2.creationDate);
  static int compareChange(TodoObject t1, TodoObject t2) => t1.changeDate.compareTo(t2.changeDate);
}
