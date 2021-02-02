import 'dart:io';
import 'package:adminyaser/component/alert.dart';
import 'package:adminyaser/component/chooseimage.dart';
import 'package:adminyaser/component/crud.dart';
import 'package:adminyaser/component/valid.dart';
import 'package:adminyaser/const.dart';
import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/request/addrequest.dart';
import 'package:flutter/material.dart';

class AddCategories extends StatefulWidget {
  AddCategories({Key key}) : super(key: key);
  @override
  _AddCategoriesState createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  // Instance Crud For Create Delete Update Read DataBase
  Crud crud = new Crud();
  // File
  File file;
  // End File
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  TextEditingController categoriesname = new TextEditingController();
  
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

  addCat() async {
    if (file == null)
      return showAlertOneChoose(
          context, "warning", "هام", "الرجاء اختيار صورة للقسم");
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      showLoading(context);
      var data = {"name": categoriesname.text};
      var responsebody =
          await addRequestWithImageOne(linkAddcategories, data, file);
      if (responsebody['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("categories");
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
        title: Text('اضافة قسم'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
            key: formstate,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildFormText("ادخل اسم القسم", categoriesname, "name"),
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
                    child: Text("اضافة القسم"),
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
          return validInput(val, 2, 20, "يكون اسم القسم");
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
