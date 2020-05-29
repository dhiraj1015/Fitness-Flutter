import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/screens/excercise_hub.dart';
import 'package:fitness_app/screens/excercise_start_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiURL =
      "https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json";

  ExcerciseHub excerciseHub;

  @override
  void initState() {
    getExcercies();
    super.initState();
  }

  void getExcercies() async {
    var response = await http.get(apiURL);
    var body = response.body;
    var decodedJson = jsonDecode(body);
    //print(body);
    excerciseHub = ExcerciseHub.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fitness App"),
        ),
        body: Container(
          child: excerciseHub != null
              ? ListView(
                  children: excerciseHub.exercises.map((e) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExcerciseStartScreen(
                                      exercises: e,
                                    )));
                      },
                      child: Hero(
                        tag: e.id,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                // child: FadeInImage(
                                //   placeholder:
                                //       AssetImage("assets/placeholder.jpg"),
                                //   image: NetworkImage(e.thumbnail),
                                //   height: 250,
                                //   width: MediaQuery.of(context).size.width,
                                //   fit: BoxFit.cover,
                                // )
                                child: CachedNetworkImage(
                                  imageUrl: e.thumbnail,
                                  placeholder: (context, url) => Image(
                                    image: AssetImage("assets/placeholder.jpg"),
                                    fit: BoxFit.cover,
                                    height: 250,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  height: 250,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Color(0xFF000000),
                                        Color(0x00000000)
                                      ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center)),
                                ),
                              ),
                              Container(
                                height: 250,
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  e.title,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : LinearProgressIndicator(),
        ));
  }
}
