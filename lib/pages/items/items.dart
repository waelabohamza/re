import 'package:adminyaser/component/crud.dart';
import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/items/listitems.dart';
import 'package:flutter/material.dart';

class Items extends StatefulWidget {
  Items({Key key}) : super(key: key);
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  
  Crud crud = new Crud();
  ScrollController _controller;
  var  message;
  List items = [];
  bool loading = true;
  int b = 0;
  getItems(int a) async {
    setState(() {
      loading = true;
    });
    var url = "$linkitems?page=$a";
    // await Future.delayed(Duration(seconds: 2));// من اجل التجربة
    var data = {"role": "admin"};
    var responsebody = await crud.writeData(url, data);
    for (int i = 0; i < responsebody.length; i++)
      if (responsebody[0] != "falid"){
        items.add(responsebody[i]);
      }
    setState(() {
      loading = false;
    });
    print(items);
  }

  @override
  void dispose() {
    _controller.dispose();
    items.clear();
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
        getItems(b);
      }
      if (_controller.offset <= _controller.position.minScrollExtent) {
        setState(() {});
      }
    });
    getItems(b);
    super.initState();
  }

  Future<void> onRefreshNow() async {
    items = [];
    b = 0;
    await getItems(b);
  }

  deleteItems(id) async {
    var data = {"id": id.toString()};
    var responsebody = await crud.writeData(linkDeleteitems, data);
    if (responsebody['status'] == "success"){
      print("success Delete");
    }
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('المنتجات'),
        ),
        floatingActionButton: Container(
            padding: EdgeInsets.only(left: mdw - 100),
            child: Container(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('additems');
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
                // Text("${items}") ,
                RefreshIndicator(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: items.length,
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
                              await deleteItems(
                                  items[i]['items_id']);
                              setState(() {
                                items.removeAt(i);
                              });
                            }
                          },
                          child: ItemsList(
                            items: items[i],
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
