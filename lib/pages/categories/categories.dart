import 'package:adminyaser/component/crud.dart';
import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/categories/categorieslist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Crud crud = new Crud();
  ScrollController _controller;
  var message;
  List categories = [];
  bool loading = true;
  int b = 0;
  getCategories(int a) async {
   if(this.mounted){
      setState(() {
      loading = true;
    });
   }
    var url = "$linkcategories?page=$a";
    // await Future.delayed(Duration(seconds: 2));// من اجل التجربة
    var response = await http.get(url);
    var responsebody = jsonDecode(response.body);
    for (int i = 0; i < responsebody.length; i++)
      if (responsebody[0] != "falid") {
        categories.add(responsebody[i]);
      }
  if(this.mounted){
      setState(() {
      loading = false;
    });
   }
    print(categories);
  }
  @override
  void dispose() {
    _controller.dispose();
    categories.clear();
    super.dispose();
  }
  @override
  void initState(){
    _controller = ScrollController();
    _controller.addListener(() {
      print(_controller.offset);
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print("maxbottom");
        b = b + 10;
        getCategories(b);
      }
      if (_controller.offset <= _controller.position.minScrollExtent) {
        setState(() {});
      }
    });
    getCategories(b);
    super.initState();
  }
  Future<void> onRefreshNow() async {
    categories = [];
    b = 0;
    await getCategories(b);
  }
  deleteCategories(id) async {
    var data = {"id": id.toString()};
    var responsebody = await crud.writeData(linkDeletecategories, data);
    if (responsebody['status'] == "success") {
      print("success Delete");
    }
  }
  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('الاقسام'),
        ),
        floatingActionButton: Container(
            padding: EdgeInsets.only(left: mdw - 100),
            child: Container(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('addcategories');
                  },
                  child: Icon(
                    Icons.add,
                    size: 40,
                  ),
                  backgroundColor: Colors.red,
                ))),
        body: WillPopScope(
            child: Stack(
              children: [
                // Text("${categories}") ,
                RefreshIndicator(
                  child: Container(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.red,
                              child: Center(
                                  child: Text("حذف نهائي",
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white))),
                            ),
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                await deleteCategories(
                                    categories[i]['categories_id']);
                                setState(() {
                                  categories.removeAt(i);
                                });
                              }
                            },
                            child: CategoriesList(
                              categories: categories[i],
                            ));
                      },
                    ),
                  ),
                  onRefresh: onRefreshNow,
                ),
                if (loading == true)
                  Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ))
              ],
            ),
            onWillPop: () {
              Navigator.of(context).pushNamed("home");
              return null;
            })
            );
  }
}
