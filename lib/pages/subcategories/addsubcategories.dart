import 'dart:io';
import 'package:adminyaser/component/alert.dart';
import 'package:adminyaser/component/chooseimage.dart';
import 'package:adminyaser/component/crud.dart';
import 'package:adminyaser/component/valid.dart';
import 'package:adminyaser/const.dart';
import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/request/addrequest.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/material.dart';

class AddSubCategories extends StatefulWidget {
  AddSubCategories({Key key}) : super(key: key);
  @override
  _AddSubCategoriesState createState() => _AddSubCategoriesState();
}

class _AddSubCategoriesState extends State<AddSubCategories> {
  // Instance Crud For Create Delete Update Read DataBase
  Crud crud = new Crud();
  // File
  File file;
  // End File
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  TextEditingController subcategoriesname = new TextEditingController();
// For ImagePicker Choose Image
  _chooseCamera() async {
    file = await myChooseCamera();
    setState(() {});
  }

  _chooseGallery() async {
    file = await myChooseGallery();
    setState(() {});
  }
  // Add Categories To DataBase

  // For DropDown

  List<dynamic> datadropdown = List();
  List<dynamic> datadropdownname = List();
  String catname;
  var catid;

  void getCatName() async {
    var listData = await crud.readData(linkcategories);
    for (int i = 0; i < listData.length; i++)
      setState(() {
        datadropdown.add(listData[i]);
        datadropdownname.add(listData[i]['categories_name']);
      });

    // print("data : $listData");
  }
  //

  @override
  void initState() {
    super.initState();
    getCatName();
  }

  addCat() async {
    if (catname == null)
      return showAlertOneChoose(
          context, "warning", "هام", "الرجاء اختيار اسم القسم");
    if (file == null)
      return showAlertOneChoose(
          context, "warning", "هام", "الرجاء اختيار صورة للقسم");
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      showLoading(context);
      var data = {"name": subcategoriesname.text, "catid": catid.toString()};
      var responsebody =
          await addRequestWithImageOne(linkAddsubcategories, data, file);
      if (responsebody['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("subcategories");
      } else {
        Navigator.of(context).pop();
        showAlertOneChoose(context, "error", "خطا", "حاول مجددا");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة قسم فرعي'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
            key: formstate,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildFormText(
                      "ادخل اسم القسم الفرعي", subcategoriesname, "name"),
                  DropdownSearch(
                    items: datadropdownname,
                    label: "ادخل هنا اسم القسم  الذي تريد",
                    mode: Mode.BOTTOM_SHEET,
                    onChanged: (val) {
                      catname = val;
                      catid = getIdByNameInList(val, datadropdown);
                      print(catid);
                      print(val);
                    },
                    selectedItem: "اسم القسم",
                  ),
                  RaisedButton(
                    color: file == null ? Colors.red : Colors.blue,
                    onPressed: () {
                      return showbottommenu(
                          context, _chooseCamera, _chooseGallery);
                    },
                    child: Text(
                      " اختيار صورة ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: addCat,
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    color: maincolor,
                    textColor: Colors.white,
                    child: Text("اضافة قسم فرعي"),
                  )
                ],
              ),
            )),
      ),
    );
  }

  buildFormText(String myhint, TextEditingController mycontorle, type) {
    return TextFormField(
      controller: mycontorle,
      validator: (val) {
        if (type == "name") {
          return validInput(val, 2, 30, "يكون اسم القسم الفرعي");
        }
        return null;
      },
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: myhint,
          prefixIcon: Icon(Icons.category)),
    );
  }
}

getIdByNameInList(String val, List list) {
  var id = list.where((element) => element['categories_name'] == val).toList();
  return id[0]['categories_id'];
}
