import 'package:flutter/material.dart';
import 'scr.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FirstPage(),
  ));
}

class FirstPage extends StatelessWidget {
  var _categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12.0,
        backgroundColor: Colors.blue,
        title: Text('Search Photos'),
        centerTitle: true,
      ),
      body: Material(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset(
                  'images/search_image.png',
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                      labelText: 'Enter a Catagory',
                      hintText: 'eg: Rick and Morty , cats, wallpaper .... ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)),
                ),
              ),
              ListTile(
                title: Material(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(
                        catagory: _categoryNameController.text,
                      )));
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {

  String catagory;
  SecondPage({this.catagory});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Photo Search',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: getPics(widget.catagory),
          builder: (context, snapShot) {
            Map data = snapShot.data;
            if (snapShot.hasError) {
              print(snapShot.error);
              return Text(
                'Conecction Issue',
                style: TextStyle(color: Colors.red, fontSize: 22.0),
              );
            } else if (snapShot.hasData) {
              return Center(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          child: InkWell(
                            onTap: () {},
                            child: Image.network(
                                '${data['hits'][index]['largeImageURL']}'),
                          ),
                        ),
                        Divider(
                          color: Colors.blue,
                          height: 4.0,
                        )
                      ],
                    );
                  },
                  itemCount: data.length,
                ),
              );
            } else if (!snapShot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return Center(
                child: Text('Something`s wrong..!'),
              );
          }),
    );
  }
}

Future<Map> getPics(String catagory) async {
  String url = 'https://pixabay.com/api/?key=$API_KEY&q=$catagory&image_type=photo';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
