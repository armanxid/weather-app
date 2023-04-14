import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage3 extends StatefulWidget {
  const HomePage3({Key? key}) : super(key: key);

  @override
  State<HomePage3> createState() => _HomePage3State();
}

class _HomePage3State extends State<HomePage3> {
  final String url = "https://ibnux.github.io/BMKG-importer/cuaca/501233.json";
  List? data;

  @override
  void initState() {
    // TODO: implement initState
    _getRefreshData();
    super.initState();
  }

  Future<void> _getRefreshData() async {
    getJsonData(context);
  }

  Future<void> getJsonData(BuildContext context) async {
    var response = await http.get(Uri.parse(url));
    print(response.body);
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RefreshIndicator(
          onRefresh: _getRefreshData,
          child: data == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: data == null ? 0 : data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(data![index]["jamCuaca"]);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Text(data![index]["cuaca"] +
                                          " " +
                                          data![index]["tempC"]),
                                      Text(data![index]["tempF"])
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
