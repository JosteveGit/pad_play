import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Lato'),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController controller = PageController();
  Color bg = Colors.red;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      print(controller.page);
      if (controller.page.round() == 0) {
        setState(() {
          bg = Colors.red;
        });
      } else {
        setState(() {
          bg = Colors.blue;
        });
      }
    });
  }

  final _currentPageNotifier = ValueNotifier<int>(0);

  double ver = 110;

  halfOnTap() {
    setState(() {
      ver = 0;
      bg = Colors.white;
    });
  }

  reverseHalfOnTap(){
    setState(() {
      ver = 110;
      if (controller.page.round() == 0) {
        setState(() {
          bg = Colors.red;
        });
      } else {
        setState(() {
          bg = Colors.blue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        color: bg,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.ease,
          margin: EdgeInsets.symmetric(vertical: ver),
          child: PageView(
            controller: controller,
            children: <Widget>[
              CardToExpand(
                  header: "JUST RED",
                  cost: r'$2000.00',
                  imageDirectory: "images/red.png",
                  halfOnTap: halfOnTap,
                  reverseHalfOnTap: reverseHalfOnTap,
              ),
              CardToExpand(
                header: "WAWE BLUE",
                cost: r'$1500.00',
                imageDirectory: "images/blue.png",
                halfOnTap: halfOnTap,
                reverseHalfOnTap: reverseHalfOnTap,
              )
            ],
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
          ),
        ),
      ),
    );
  }
}

class CardToExpand extends StatefulWidget {
  final String header;
  final String cost;
  final String imageDirectory;
  final Function halfOnTap;
  final Function reverseHalfOnTap;

  CardToExpand({this.header, this.cost, this.imageDirectory, this.halfOnTap, this.reverseHalfOnTap});

  @override
  _CardToExpandState createState() => _CardToExpandState();
}

class _CardToExpandState extends State<CardToExpand>
    with TickerProviderStateMixin {
  double hor = 30;
  double ele = 6.0;
  double imageVerticalMarginValue = 10;
  double imageHorizontalMarginValue = 40;
  bool offstage = false;
  var rotationTween =
      Tween<double>(begin: 0, end: 0.5).chain(CurveTween(curve: Curves.ease));
  var scaleTween = Tween<double>(begin: 1, end: 1.3)
      .chain(CurveTween(curve: Curves.bounceIn));
  var slideTween = Tween<Offset>(begin: Offset.zero, end: Offset(0, -0.5))
      .chain(CurveTween(curve: Curves.bounceIn));
  var headerSlideTween =
      Tween<Offset>(begin: Offset(-1, -2), end: Offset(0, -2))
          .chain(CurveTween(curve: Curves.ease));
  var bodySlideTween = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -0.7))
      .chain(CurveTween(curve: Curves.ease));

  AnimationController commonController;
  AnimationController scaleController;
  AnimationController slideController;

  @override
  void initState() {
    super.initState();
    commonController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
      margin: EdgeInsets.symmetric(horizontal: hor),
      child: GestureDetector(
        onTap: () {
          widget.halfOnTap();
          setState(() {
            hor = 0;
            ele = 0;
            offstage = true;
            imageVerticalMarginValue = 0;
            imageHorizontalMarginValue = 0;
            commonController.forward();
          });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: ele,
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.ease,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView(
              children: <Widget>[
                Offstage(
                  offstage: offstage,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.header,
                        style: TextStyle(fontFamily: 'Lato', fontSize: 30),
                      ),
                      Text(widget.cost,
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 20,
                              color: Colors.grey)),
                    ],
                  ),
                ),
                SlideTransition(
                  position: commonController.drive(slideTween),
                  child: ScaleTransition(
                    scale: commonController.drive(scaleTween),
                    child: RotationTransition(
                      turns: commonController.drive(rotationTween),
                      child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          margin: EdgeInsets.symmetric(
                              vertical: imageVerticalMarginValue,
                              horizontal: imageHorizontalMarginValue),
                          child: GestureDetector(child: Image.asset(widget.imageDirectory),
                            onTap: (){
                              widget.reverseHalfOnTap();
                              hor = 30;
                              ele = 6.0;
                              offstage = false;
                              imageVerticalMarginValue = 10;
                              imageHorizontalMarginValue = 40;
                              commonController.reverse();
                            },
                          )
                      ),
                    ),
                  ),
                ),
                SlideTransition(
                  position: commonController.drive(headerSlideTween),
                  child: Offstage(
                    offstage: !offstage,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Text(
                          widget.header
                              .toUpperCase()
                              .substring(0, widget.header.indexOf(" ")),
                          style: TextStyle(
                            fontSize: 100,
                            color: widget.header.toLowerCase() == "wawe blue"
                                ? Colors.blueAccent[100]
                                : Colors.redAccent[100],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 80,
                          child: Text(
                            widget.header.toUpperCase().substring(
                                widget.header.indexOf(" "),
                                widget.header.length),
                            style: TextStyle(
                              fontSize: 100,
                              color: widget.header.toLowerCase() == "wawe blue"
                                  ? Colors.blueAccent[100]
                                  : Colors.redAccent[100],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SlideTransition(
                  position: commonController.drive(bodySlideTween),
                  child: Offstage(
                    offstage: !offstage,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Align(
                            child: Text(
                              "DualShock 4",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 25),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Align(
                            child: Text(
                              "Wireless Controller",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 30),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Align(
                            child: Text(
                              "The DualShock 4 Wireless Controller Playstation 4 defines the next generation of play. combining revolutionary new features with intuitive precision controls.",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 20),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Center(
                              child: Container(
                                child: Text(
                                  "BUY",
                                  style: TextStyle(
                                      color: widget.header.toLowerCase() ==
                                              "wawe blue"
                                          ? Colors.blueAccent[100]
                                          : Colors.redAccent[100],
                                      fontSize: 17),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 70),
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: widget.header.toLowerCase() == "wawe blue"
                                                ? Colors.blueAccent[100]
                                                : Colors.redAccent[100],
                                            width: 2),
                                        bottom: BorderSide(
                                            color: widget.header.toLowerCase() ==
                                                    "wawe blue"
                                                ? Colors.blueAccent[100]
                                                : Colors.redAccent[100],
                                            width: 2),
                                        left: BorderSide(
                                            color: widget.header.toLowerCase() ==
                                                    "wawe blue"
                                                ? Colors.blueAccent[100]
                                                : Colors.redAccent[100],
                                            width: 2),
                                        right: BorderSide(
                                            color: widget.header.toLowerCase() ==
                                                    "wawe blue"
                                                ? Colors.blueAccent[100]
                                                : Colors.redAccent[100],
                                            width: 2)),
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                            Offstage(
                              offstage: !offstage,
                              child: Text(
                                widget.cost,
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: offstage,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "DUALSHOCK 4",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
