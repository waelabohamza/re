import 'package:adminyaser/component/crud.dart';
import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/subcategories/listsubcategories.dart';
import 'package:flutter/material.dart';

class SubCategories extends StatefulWidget {
  SubCategories({Key key}) : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  Crud crud = new Crud();

  ScrollController _controller;
  var  message;
  List subcategories = [];
  bool loading = true;
  int b = 0;
  getSubCategories(int a) async {
    setState(() {
      loading = true;
    });
    var url = "$linksubcategories?page=$a";
    // await Future.delayed(Duration(seconds: 2));// من اجل التجربة
    var data = {"role": "admin"};
    var responsebody = await crud.writeData(url, data);
    for (int i = 0; i < responsebody.length; i++)
      if (responsebody[0] != "falid") {
        subcategories.add(responsebody[i]);
      }
    setState(() {
      loading = false;
    });
    print(subcategories);
  }

  @override
  void dispose() {
    _controller.dispose();
    subcategories.clear();
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
        getSubCategories(b);
      }
      if (_controller.offset <= _controller.position.minScrollExtent) {
        setState(() {});
      }
    });
    getSubCategories(b);
    super.initState();
  }

  Future<void> onRefreshNow() async {
    subcategories = [];
    b = 0;
    await getSubCategories(b);
  }
  deleteSubCategories(id) async {
    var data = {"id": id.toString()};
    var responsebody = await crud.writeData(linkDeletesubcategories, data);
    if (responsebody['status'] == "success") {
      print("success Delete");
    }
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('الاقسام الفرعية'),
        ),
        floatingActionButton: Container(
            padding: EdgeInsets.only(left: mdw - 100),
            child: Container(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('addsubcategories');
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
                // Text("${subcategories}") ,
                RefreshIndicator(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: subcategories.length,
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
                              await deleteSubCategories(
                                  subcategories[i]['subcategories_id']);
                              setState(() {
                                subcategories.removeAt(i);
                              });
                            }
                          },
                          child: SubCategoriesList(
                            subcategories: subcategories[i],
                          ));
                    },
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
            }));
  }
}
