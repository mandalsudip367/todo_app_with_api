import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToToDoList extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final todo;
  const AddToToDoList({super.key, this.todo});

  @override
  State<AddToToDoList> createState() => _AddToToDoListState();
}

class _AddToToDoListState extends State<AddToToDoList> {
  TextEditingController titlecontroler = TextEditingController();
  TextEditingController desccontroler = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['description'];
      titlecontroler.text = title;
      desccontroler.text = desc;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      appBar: AppBar(
          title: Text(isEdit ? 'Edit Task' : 'Create Task'),
          elevation: 0.1,
          backgroundColor: Colors.transparent),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: titlecontroler,
            decoration: const InputDecoration(hintText: 'Enter Task'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: desccontroler,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Enter Description'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: isEdit
                  ? () async {
                      await edit();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  : () async {
                      await post();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
              child: Text(isEdit ? 'Edit' : 'Add')),
        )
      ]),
    );
  }

  Future<void> edit() async {
    final todo = widget.todo;
    final id = todo['_id'];
    final title = titlecontroler.text;
    final desc = desccontroler.text;
    final body = {"title": title, "description": desc, "is_completed": false};
    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    // ignore: unused_local_variable
    var res = http.put(url,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
  }

  Future<void> post() async {
    var title = titlecontroler.text;
    var desc = desccontroler.text;
    var body = {"title": title, "description": desc, "is_completed": false};
    final url = Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=10");
    // ignore: unused_local_variable
    var res = await http.post(url,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
  }
}
