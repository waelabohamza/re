import 'dart:io';
import 'package:adminyaser/component/alert.dart';
import 'package:adminyaser/component/crud.dart';
import 'package:adminyaser/const.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Crud crud = new Crud();
  var counts;
  bool loading = true;

  // getcountall() async {
  //   counts = await crud.readData("countall");
  //   setState(() {
  //     loading = false;
  //   });
  //   print(counts);
  // }

  @override
  void initState() {
    // getcountall();
    super.initState();
  }

  Future<bool> _onWillPop() {
    return showAlert(context, "error", "تنبيه", "هل تريد اغلاق التطيبق", () {},
            () {
          exit(0);
        }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            key: _scaffoldKey,
            body: WillPopScope(
                child: loading == false
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          Stack(
                            children: [
                              buildTopRaduis(mdw),
                              buildTopText(mdw),
                              Container(
                                margin: EdgeInsets.only(top: 200),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              // Navigator.of(context)
                                              //     .pushNamed("restaurants");
                                            },
                                            child: Container(
                                              height: 170,
                                              child: Card(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Icon(
                                                      Icons.person,
                                                      size: 70,
                                                      color: maincolor,
                                                    )),
                                                    Text(
                                                      "المستخدمين",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamed("categories");
                                            },
                                            child: Container(
                                              height: 170,
                                              child: Card(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Icon(
                                                      Icons.category,
                                                      size: 70,
                                                      color: maincolor,
                                                    )),
                                                    Text(
                                                      "الاقسام",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamed("subcategories");
                                            },
                                            child: Container(
                                              height: 170,
                                              child: Card(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Icon(
                                                      Icons.category_outlined,
                                                      size: 70,
                                                      color: maincolor,
                                                    )),
                                                    Text(
                                                      "الاقسام الفرعية",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamed("items");
                                            },
                                            child: Container(
                                              height: 170,
                                              child: Card(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Icon(
                                                      Icons.access_time_rounded,
                                                      size: 70,
                                                      color: maincolor,
                                                    )),
                                                    Text(
                                                      "المنتجات",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                onWillPop: _onWillPop)));
  }

  Transform buildTopRaduis(mdw) {
    return Transform.scale(
        scale: 2,
        child: Transform.translate(
          offset: Offset(0, -200),
          child: Container(
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(mdw)),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.green, Colors.blue]),
            ),
          ),
        ));
  }

  Padding buildTopText(mdw) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("لوحة القيادة",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              // IconButton(
              //     icon: Icon(
              //       Icons.menu,
              //       color: Colors.white,
              //       size: 30,
              //     ),
              //     onPressed: () {
              //       _scaffoldKey.currentState.openDrawer();
              //     }),
              Expanded(child: Container()),
              Text("  AlMutajar AlArabi  ",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
