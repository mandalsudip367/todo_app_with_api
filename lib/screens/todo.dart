import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'addtodo.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool isLoading = true;
  List items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Text('Developed By Sudip'),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text(
            'ToDo List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0.1,
          backgroundColor: Colors.transparent),
      backgroundColor: Colors.orange.shade200,
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigatetoadd(),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.add),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        // ignore: sort_child_properties_last
        child: const Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: () => get(),
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
                child: Text(
              'Add Tasks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            )),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final id = item['_id'];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'Edit') {
                        navigatetoedit(item);
                      } else if (value == 'Delete') {
                        delete(id);
                      }
                    },
                    color: Colors.transparent,
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          // ignore: sort_child_properties_last
                          child: Text('Edit'),
                          value: 'Edit',
                        ),
                        const PopupMenuItem(
                          // ignore: sort_child_properties_last
                          child: Text('Delete'),
                          value: 'Delete',
                        )
                      ];
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future navigatetoedit(item) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddToToDoList(todo: item),
        ));
    setState(() {
      isLoading = true;
    });
    get();
  }

  Future navigatetoadd() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddToToDoList(),
        ));
    setState(() {
      isLoading = true;
    });
    get();
  }

  Future<void> get() async {
    final url = Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=10");
    var res = await http.get(url);
    var body = jsonDecode(res.body);
    setState(() {
      items = body['items'];
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> delete(String id) async {
    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    // ignore: unused_local_variable
    var res = await http.delete(url);
    final filtered = items.where((element) => element['_id'] != id).toList();
    setState(() {
      items = filtered;
    });
  }

  @override
  void initState() {
    get();
    super.initState();
  }
}
