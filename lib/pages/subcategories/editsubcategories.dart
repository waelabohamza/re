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

class EditSubCategories extends StatefulWidget {
  final subcategories;
  EditSubCategories({Key key, this.subcategories}) : super(key: key);
  @override
  _EditSubCategoriesState createState() => _EditSubCategoriesState();
}

class _EditSubCategoriesState extends State<EditSubCategories> {
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
    catid = widget.subcategories['subcategories_cat'] ; 
  }

  editCat() async {
  
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      showLoading(context);
      var data = {
        "name": subcategoriesname.text,
        "catid": catid.toString(),
        "id": widget.subcategories['subcategories_id']
      };
      var responsebody =
          await addRequestWithImageOne(linkEditsubcategories, data, file);
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
        title: Text('تعديل بيانات القسم الفرعي'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
            key: formstate,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildFormText(widget.subcategories['subcategories_name'],
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
                    selectedItem: widget.subcategories['categories_name'],
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

  buildFormText(String initialval, String myhint,
      TextEditingController mycontorle, type) {
    mycontorle.text = initialval;
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
