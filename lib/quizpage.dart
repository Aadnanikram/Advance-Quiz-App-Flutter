import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizstar/resultpage.dart';

class getjson extends StatelessWidget {
  // accept the langname as a parameter

  String langname;

  getjson(this.langname);

  String assettoload;

  // a function
  // sets the asset to a particular JSON file
  // and opens the JSON
  setasset() {
    if (langname == "Python") {
      assettoload = "assets/python.json";
    } else if (langname == "Java") {
      assettoload = "assets/java.json";
    } else if (langname == "Javascript") {
      assettoload = "assets/js.json";
    } else if (langname == "C++") {
      assettoload = "assets/cpp.json";
    } else {
      assettoload = "assets/linux.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    // this function is called before the build so that
    // the string assettoload is avialable to the DefaultAssetBuilder
    setasset();
    // and now we return the FutureBuilder to load and decode JSON
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString(assettoload, cache: false),
      builder: (context, snapshot) {
        List mydata = json.decode(snapshot.data.toString());
        if (mydata == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          return quizpage(mydata: mydata);
        }
      },
    );
  }
}

class quizpage extends StatefulWidget {
  final List mydata;

  quizpage({Key key, @required this.mydata}) : super(key: key);

  @override
  _quizpageState createState() => _quizpageState(mydata);
}

class _quizpageState extends State<quizpage> {
  final List mydata;

  _quizpageState(this.mydata);

  Color colortoshow = Colors.greenAccent;
  Color right = Colors.greenAccent;
  Color wrong = Colors.red;
  Color selected = Colors.black12;
  int marks = 0;
  int i = 1;
  bool disableAnswer = false;

  // extra varibale to iterate
  int j = 1;
  double timer = 30;
  double showtimer = 30;
  var random_array;
  List<String> selected_awnser = <String>[];
  String select = "";
  Timer T;

  Map<String, Color> btncolor = {
    "a": Colors.cyan,
    "b": Colors.cyan,
    "c": Colors.cyan,
    "d": Colors.cyan,
  };

  bool canceltimer = false;

  // code inserted for choosing questions randomly
  // to create the array elements randomly use the dart:math module
  // -----     CODE TO GENERATE ARRAY RANDOMLY

  genrandomarray() {
    var distinctIds = [];
    var rand = new Random();
    for (int i = 0;;) {
      distinctIds.add(rand.nextInt(10) + 1);

      random_array = distinctIds.toSet().toList();
      if (random_array.length < 10) {
        continue;
      } else {
        break;
      }
    }
    i = random_array[0];
    print(random_array);
  }

  //   var random_array;
  //   var distinctIds = [];
  //   var rand = new Random();
  //     for (int i = 0; ;) {
  //     distinctIds.add(rand.nextInt(10));
  //       random_array = distinctIds.toSet().toList();
  //       if(random_array.length < 10){
  //         continue;
  //       }else{
  //         break;
  //       }
  //     }
  //   print(random_array);

  // ----- END OF CODE
  // var random_array = [1, 6, 7, 2, 4, 10, 8, 3, 9, 5];

  // overriding the initstate function to start timer as this screen is created
  @override
  void initState() {
    starttimer();
    genrandomarray();
    super.initState();
  }

  // overriding the setstate function to be called only if mounted
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    T = new Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          print("cancel t t");
          t.cancel();
          nextbtn();
        } else if (canceltimer == true) {
          t.cancel();
          print("cancel t c");
        } else {
          timer = timer - 1;
        }
        showtimer = timer;
      });
    });
  }

  void nextquestion() {
    canceltimer = false;
    timer = 30;
    setState(() {
      if (j < 10) {
        i = random_array[j];
        j++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => resultpage(
              mydata: mydata,
              selected_awnser: selected_awnser,
              random_array: random_array),
        ));
      }
      btncolor["a"] = Colors.cyan;
      btncolor["b"] = Colors.cyan;
      btncolor["c"] = Colors.cyan;
      btncolor["d"] = Colors.cyan;
      disableAnswer = false;
    });
    T.cancel();
    starttimer();
  }

  void checkanswer(String k) {
    // in the previous version this was
    // mydata[2]["1"] == mydata[1]["1"][k]
    // which i forgot to change
    // so nake sure that this is now corrected
    // if (mydata[2][i.toString()] == mydata[1][i.toString()][k]) {
    //   // just a print sattement to check the correct working
    //   // debugPrint(mydata[2][i.toString()] + " is equal to " + mydata[1][i.toString()][k]);
    //   marks = marks + 1;
    //   // changing the color variable to be green
    //   // colortoshow = right;
    // }
    colortoshow = selected;
    setState(() {
      // applying the changed color to the particular button that was selected

      btncolor["a"] = Colors.cyan;
      btncolor["b"] = Colors.cyan;
      btncolor["c"] = Colors.cyan;
      btncolor["d"] = Colors.cyan;

      btncolor[k] = colortoshow;
      select = k;

      // canceltimer = true;
      // disableAnswer = true;
    });
    // nextquestion();
    // changed timer duration to 1 second
  }

  void nextbtn() {
    if (select != "") {
      selected_awnser.add(select);
      select = "";
    } else {
      selected_awnser.add("");
    }

    setState(() {
      canceltimer = true;
      disableAnswer = true;
    });
    nextquestion();
  }

  Widget choicebutton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child: Row(
          children: [
            Text(
              k.toUpperCase()+":      ",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Alike",
                fontSize: 19.0,
              ),
            ),
            Text(
              mydata[1][i.toString()][k],
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Alike",
                fontSize: 16.0,
              ),
              maxLines: 1,
            ),
          ],
        ),
        color: btncolor[k],
        splashColor: Colors.blueGrey,
        highlightColor: Colors.blueGrey,
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(showtimer);
    double a = ((showtimer * 10) / 3) / 100;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    "Quizstar",
                  ),
                  content: Text("Never go back."),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Ok',
                      ),
                    )
                  ],
                ));
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            LinearProgressIndicator(
              valueColor: new AlwaysStoppedAnimation(Colors.tealAccent),
              value: a,
              backgroundColor: Colors.black
              ,
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(top: 15.0),
                padding: EdgeInsets.all(20.0),
                child: Text(
                  mydata[0][i.toString()],
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: AbsorbPointer(
                absorbing: disableAnswer,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      choicebutton('a'),
                      choicebutton('b'),
                      choicebutton('c'),
                      choicebutton('d'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: OutlineButton(
                    onPressed: () => nextbtn(),
                    child: Text(
                      "Go to Next",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    borderSide: BorderSide(width: 3.0, color: Colors.black),
                    splashColor: Colors.cyan,
                  ),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
