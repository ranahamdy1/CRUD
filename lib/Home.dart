import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test2/sqldb.dart';

import 'editnotes.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SqlDb sqlDb = SqlDb();
  List tips = [];
  bool isLoading = true;

  Future readData() async {
    List<Map> response = await sqlDb.readData("SELECT * FROM tips");
    tips.addAll(response);

    isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'tips ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addTips");
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: isLoading == true
          ? const Center(child: Text("Loading..."))
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  ListView.builder(
                      itemCount: tips.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Card(
                            child: ListTile(
                                title: Text("${tips[i]['day']}"),
                                subtitle: Text("${tips[i]['tip']}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => EditTips(
                                                      tip: tips[i]['tip'],
                                                      day: tips[i]['day'],
                                                      id: tips[i]['id'],
                                                    )));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                        size: 22,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        int response =
                                            await sqlDb.deleteData('''
                                DELETE FROM tips WHERE id =${tips[i]['id']}
                                ''');
                                        if (response > 0) {
                                          tips.removeWhere((element) =>
                                              element['id'] == tips[i]['id']);
                                          setState(() {});
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                )));
                      })
                ],
              ),
            ),
    );
  }
}
