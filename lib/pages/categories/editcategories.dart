import 'dart:io';
import 'package:adminyaser/component/alert.dart';
import 'package:adminyaser/component/chooseimage.dart';
import 'package:adminyaser/component/crud.dart';
import 'package:adminyaser/component/valid.dart';
import 'package:adminyaser/const.dart';
import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/request/addrequest.dart';
import 'package:flutter/material.dart';

class EditCategories extends StatefulWidget{
  final categories ; 
  EditCategories({this.categories});
  @override
  _EditCategoriesState createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
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

  editCat() async{
    // if (file == null)
    //   return showAlertOneChoose(
    //       context, "warning", "هام", "الرجاء اختيار صورة للقسم");
    var formdata = formstate.currentState;
    if (formdata.validate()){
      showLoading(context);
      var data = {"name": categoriesname.text , "id" : widget.categories['categories_id']};
      var responsebody =
          await addRequestWithImageOne(linkEditcategories, data, file);
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
        title: Text('تعديل بيانات القسم'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
            key: formstate,
            child: SingleChildScrollView(
              child: Column(
                children:[
                  buildFormText(  widget.categories['categories_name'] ,  "ادخل اسم القسم", categoriesname, "name"),
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
                    onPressed: editCat,
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    color: maincolor,
                    textColor: Colors.white,
                    child: Text("حفظ التعديلات"),
                  )
                ],
              ),
            )),
      ),
    );
  }

  buildFormText(String initialval ,    String myhint, TextEditingController mycontorle, type) {
    mycontorle.text = initialval ; 
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
