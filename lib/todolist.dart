import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoNew extends StatefulWidget {
  const TodoNew({Key? key}) : super(key: key);

  @override
  State<TodoNew> createState() => _TodoNewState();
}

class _TodoNewState extends State<TodoNew> {
  TextEditingController taskController = TextEditingController();
  List<String> todoItems = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  
  void loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todoItems = prefs.getStringList('items') ?? [];
    });
  }

  
  void saveItems(List<String> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('items', items);
  }

  
  void addItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        todoItems.add(task);
      });
      saveItems(todoItems);
      taskController.clear();
    }
  }

  
  void removeItem(int index) {
    setState(() {
      todoItems.removeAt(index);
    });
    saveItems(todoItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 50,
                width: 250,
                child: TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Task",
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  addItem(taskController.text);
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todoItems[index]),
                  trailing: GestureDetector(
                    onTap: () {
                      removeItem(index);
                    },
                    child: Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}