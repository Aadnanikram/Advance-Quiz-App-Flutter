import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizstar/quizpage.dart';

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  List<String> images = [
    "images/py.png",
    "images/java.png",
    "images/js.png",
    "images/cpp.png",
    "images/linux.png",
  ];

  List<String> des = [
    "Python is one of the most popular and fastest programming language since half a decade.\nIf You think you have learnt it.. \nJust test yourself !!",
    "Java has always been one of the best choices for Enterprise World. If you think you have learn the Language...\nJust Test Yourself !!",
    "Javascript is one of the most Popular programming language supporting the Web.\nIt has a wide range of Libraries making it Very Powerful !",
    "C++, being a statically typed programming language is very powerful and Fast.\nit's DMA feature makes it more useful. !",
    "Linux is a OPEN SOURCE Operating System which powers many Servers and Workstation.\nIt is also a top Priority in Developement Work !",
  ];

  Widget customcard(String langname, String image, String des){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 60.0,
      ),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => getjson(langname),
          ));
        },
        child: Material(
          color: Colors.cyan,
          elevation: 5.0,
          borderRadius: BorderRadius.circular(80.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(

                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(                    // changing from 200 to 150 as to look better
                        height: 60.0,
                        width: 60.0,
                        child: ClipOval(
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              image,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      langname,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: "Quando",
                        fontWeight: FontWeight.w700,
                        
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown, DeviceOrientation.portraitUp
    ]);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: new BoxDecoration(
                color: Colors.cyan,
                boxShadow: [
                  new BoxShadow(blurRadius: 40.0)
                ],
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0)),
              ),
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  "Computer Science"
                      " Subjects",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Quando",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: ListView(
              children: <Widget>[
                customcard("C++", images[3], des[3]),
                customcard("Javascript", images[2], des[2]),
                customcard("Linux", images[4], des[4]),
                customcard("Python", images[0], des[0]),
                customcard("Java", images[1], des[1]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}