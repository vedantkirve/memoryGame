import 'package:flutter/material.dart';
import 'package:memory_game/data/data.dart';
import 'package:memory_game/model/tile_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pairs = getPairs();
    pairs.shuffle();

    visiblePairs = pairs;
    selected = true;

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        visiblePairs = getQuestions();
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            points != 800
                ? Column(
                    children: <Widget>[
                      Text(
                        "$points/800",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text("POINTS"),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            points != 800
                ? GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 0.0,
                      maxCrossAxisExtent: 100,
                    ),
                    children: List.generate(pairs.length, (index) {
                      return Tile(
                        imageAssetPath: visiblePairs[index].getImageAssetPath(),
                        parent: this,
                        tileIndex: index,
                      );
                    }))
                : GestureDetector(
                    onTap: () {
                      print("presed");
                      //trying to use phoenix.rebirth but isnt working
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text(
                        "Replay",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Tile extends StatefulWidget {
  String imageAssetPath;
  int tileIndex;

  _HomePageState parent;

  Tile({this.imageAssetPath, this.parent, this.tileIndex});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          if (selectedImageAssetPath != "") {
            if (selectedImageAssetPath ==
                pairs[widget.tileIndex].getImageAssetPath()) {
              print("correct choice");
              selected = true;

              Future.delayed(const Duration(seconds: 2), () {
                points = points + 100;

                setState(() {});
                selected = false;

                widget.parent.setState(() {
                  pairs[widget.tileIndex].setImageAssetPath("");
                  pairs[selectedTileIndex].setImageAssetPath("");
                });
                selectedImageAssetPath = "";
              });
            } else {
              print("wrong choice");
              selected = true;
              //points = points - 50;

              Future.delayed(const Duration(seconds: 2), () {
                selected = false;
                widget.parent.setState(() {
                  pairs[widget.tileIndex].setIsSelected(false);
                  pairs[selectedTileIndex].setIsSelected(false);
                });

                selectedImageAssetPath = "";
              });
            }
          } else {
            selectedTileIndex = widget.tileIndex;
            selectedImageAssetPath =
                pairs[widget.tileIndex].getImageAssetPath();
          }

          setState(() {
            pairs[widget.tileIndex].setIsSelected(true);
          });
          print("clciked");
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: pairs[widget.tileIndex].getImageAssetPath() != ""
            ? Image.asset(pairs[widget.tileIndex].getIsSelected()
                ? pairs[widget.tileIndex].getImageAssetPath()
                : widget.imageAssetPath)
            : Image.asset("assets/correct.png"),
      ),
    );
  }
}
