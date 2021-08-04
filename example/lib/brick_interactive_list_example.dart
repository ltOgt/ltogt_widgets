import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Brick Button Example',
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: const Color(0xFF232324), // TODO consider using this as default background1
        body: Center(
          child: Container(
            height: 500,
            padding: EdgeInsets.all(50),
            child: TodoWidget(),
          ),
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
    return BrickThemeProvider.adjustLocal(
      context: context,
      changeExisting: (BrickTheme existing) => BrickTheme(
        // TODO consider using this color as default background2. generally like idea of dark blues
        color: existing.color.copyWith(background2: const Color(0xFF121214)),
        shadow: existing.shadow,
        radius: existing.radius,
      ),
      child: BrickInteractiveList(
        childData: todos
            .map((e) => ChildDataBIL<TodoObject>(
                  data: e,
                  build: (c, matches) => e.build(c, matches, update),
                ))
            .toList(),
        childDataParameters: const [
          taskPARAM,
          userPARAM,
          createPARAM,
          changePARAM,
          donePARAM,
        ],
        topBarTrailing: [
          SIZED_BOX_5,
          const BrickIconButton(
            icon: Icon(Icons.refresh),
          ),
          SIZED_BOX_5,
          BrickIconButton(
            onPressed: (_) {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

const taskPARAM = ParameterBIL<TodoObject>(
  name: "TASK",
  sort: TodoObject.compareTask,
  searchStringExtractor: TodoObject.extractTask,
);
const userPARAM = ParameterBIL<TodoObject>(
  name: "USER",
  sort: TodoObject.compareUser,
  searchStringExtractor: TodoObject.extractUser,
);
const createPARAM = ParameterBIL<TodoObject>(
  name: "CREATE",
  sort: TodoObject.compareCreate,
);
const changePARAM = ParameterBIL<TodoObject>(
  name: "CHANGE",
  sort: TodoObject.compareChange,
);
const donePARAM = ParameterBIL<TodoObject>(
  name: "DONE",
  sort: TodoObject.compareDone,
);

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

  Widget build(BuildContext context, StringOffsetByParameterName? matches, [Function()? setState]) {
    StringOffset? taskMatch, userMatch;
    taskMatch = matches?[taskPARAM.name];
    userMatch = matches?[userPARAM.name];

    return Padding(
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
              taskMatch == null
                  ? Text("TASK: $taskName")
                  : MatchText(text: "TASK: $taskName", match: taskMatch.offset(6)),
              userMatch == null
                  ? Text("USER: $userName")
                  : MatchText(text: "USER: $userName", match: userMatch.offset(6)),
              Text("CREATED: $creationDate"),
              Text("CHANGED: $changeDate"),
            ],
          ),
        ],
      ),
    );
  }

  static int compareDone(TodoObject t1, TodoObject t2) => (t2.isDone == t1.isDone) ? 0 : (t2.isDone ? 1 : -1);
  static int compareTask(TodoObject t1, TodoObject t2) => t1.taskName.compareTo(t2.taskName);
  static int compareUser(TodoObject t1, TodoObject t2) => t1.userName.compareTo(t2.userName);
  static int compareCreate(TodoObject t1, TodoObject t2) => t1.creationDate.compareTo(t2.creationDate);
  static int compareChange(TodoObject t1, TodoObject t2) => t1.changeDate.compareTo(t2.changeDate);

  static String extractTask(TodoObject t) => t.taskName;
  static String extractUser(TodoObject t) => t.userName;
}
