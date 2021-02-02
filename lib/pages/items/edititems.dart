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

class EditItems extends StatefulWidget {
  final items ; 
  EditItems({Key key , this.items}) : super(key: key);
  @override
  _EditItemsState createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  // Instance Crud For Create Delete Update Read DataBase
  Crud crud = new Crud();
  // File
  File file;
  File filetwo;
  // End File
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  TextEditingController itemsname = new TextEditingController();
  TextEditingController desc = new TextEditingController();
  TextEditingController point = new TextEditingController();
  TextEditingController discount = new TextEditingController();
  TextEditingController usa = new TextEditingController();
  TextEditingController uae = new TextEditingController();
  TextEditingController ir = new TextEditingController();
  TextEditingController rs = new TextEditingController();
// For ImagePicker Choose Image
  _chooseCameraone() async {
    file = await myChooseCamera();
    setState(() {});
  }

  _chooseGalleryone() async {
    file = await myChooseGallery();
    setState(() {});
  }

  _chooseCameratwo() async {
    filetwo = await myChooseCamera();
    setState(() {});
  }

  _chooseGallerytwo() async {
    filetwo = await myChooseGallery();
    setState(() {});
  }
 

  @override
  void initState() {
    super.initState();
    
  }

  editItem() async {
    

    var formdata = formstate.currentState;
    if (formdata.validate()) {
      showLoading(context);
      var data = {
        "name": itemsname.text.toString(),
        "point": point.text.toString(),
        "price": usa.text.toString(),
        "desc": desc.text.toString(),
        "discount": discount.text.toString(),
        "priceem": uae.text.toString(),
        "priceir": ir.text.toString(),
        "pricesa": rs.text.toString(),
        "offers": offer.toString()
      };
      var responsebody =
          await addRequestAndImageTwo(linkAdditems, data, file, filetwo);
      if (responsebody['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("items");
      } else {
        Navigator.of(context).pop();
        showAlertOneChoose(context, "error", "خطا", "حاول مجددا");
      }
    }
  }

  int offer = 0;
  @override
  void dispose(){
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة منتج'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
            key: formstate,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // buildFormText("ادخل اسم المنتج الفرعي", itemsname, "name"),
                  buildFormText("ادخل اسم المنتج الفرعي", Icons.insert_comment,
                      itemsname, "name"),
                  buildFormText("ادخل الوصف", Icons.article, desc, "desc"),
                  Row(
                    children: [
                      Expanded(
                        child: buildFormText(
                            "النقاط", Icons.control_point, point, "point"),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: buildFormText("ادخل الخصم", Icons.local_offer,
                            discount, "discount"),
                      ),
                    ],
                  ),
                  Text("الاسعار"),
                  Row(
                    children: [
                      Expanded(
                        child: buildFormText(
                            "بالدولار", Icons.monetization_on, usa, "USA"),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: buildFormText(
                            "بالريال", Icons.monetization_on, rs, "RS"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildFormText("بالدينار العراقي",
                            Icons.monetization_on, ir, "IR"),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: buildFormText("بالدرهم الاماراتي",
                            Icons.point_of_sale_outlined, uae, "UAE"),
                      ),
                    ],
                  ),
                  // Text("العرض"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("لا يوجد عرض"),
                      Radio(
                          value: 0,
                          groupValue: offer,
                          onChanged: (val) {
                            setState(() {
                              offer = val;
                            });
                            print(offer);
                          }),
                      SizedBox(width: 20),
                      Text("يوجد عرض"),
                      Radio(
                          value: 1,
                          groupValue: offer,
                          onChanged: (val) {
                            setState(() {
                              offer = val;
                            });
                            print(offer);
                          })
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        color: file == null ? Colors.red : Colors.blue,
                        onPressed: () {
                          return showbottommenu(
                              context, _chooseCameraone, _chooseGalleryone);
                        },
                        child: Text(
                          " اختيار صورى القائمة ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        color: filetwo == null ? Colors.red : Colors.blue,
                        onPressed: () {
                          return showbottommenu(
                              context, _chooseCameratwo, _chooseGallerytwo);
                        },
                        child: Text(
                          " اختيار صورى التفاصيل ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    onPressed: editItem,
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    color: maincolor,
                    textColor: Colors.white,
                    child: Text("اضافة منتج"),
                  )
                ],
              ),
            )),
      ),
    );
  }

  buildFormText(String myhint, icon, TextEditingController mycontorle, type) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: mycontorle,
        validator: (val) {
          if (type == "name") {
            return validInput(val, 1, 40, "يكون اسم القسم الفرعي");
          }
          if (type == "point") {
            return validInput(val, 0, 10, "يكون النقاط");
          }
          if (type == "desc") {
            return validInput(val, 1, 255, "يكون الوصف");
          }
          if (type == "discount") {
            return validInput(val, 0, 3, "يكون الخصم");
          }
          if (type == "USA") {
            return validInput(val, 1, 3, "يكون الدولار");
          }
          if (type == "UAE") {
            return validInput(val, 1, 4, "يكون الدرهم");
          }
          if (type == "IR") {
            return validInput(val, 1, 5, "يكون الدينار");
          }
          if (type == "RS") {
            return validInput(val, 1, 4, "يكون الريال");
          }
          return null;
        },
        keyboardType: (type == "name" || type == "desc")
            ? TextInputType.text
            : TextInputType.number,
        maxLines: type == "desc" ? 6 : 1,
        minLines: 1,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: myhint,
            prefixIcon: Icon(icon)),
      ),
    );
  }
}

getIdByNameInListCat(String val, List list) {
  var id = list.where((element) => element['categories_name'] == val).toList();
  return id[0]['categories_id'];
}

getIdByNameInListSubCat(String val, List list) {
  var id =
      list.where((element) => element['subcategories_name'] == val).toList();
  return id[0]['subcategories_id'];
}
