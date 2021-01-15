import 'package:adminyaser/component/alert.dart';
import 'package:adminyaser/component/crud.dart';
import 'package:adminyaser/component/valid.dart';
import 'package:adminyaser/const.dart';
import 'package:adminyaser/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AddCodes extends StatefulWidget {
  final itemsid;
  AddCodes({Key key, this.itemsid}) : super(key: key);

  @override
  _AddCodesState createState() => _AddCodesState();
}

class _AddCodesState extends State<AddCodes> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  Crud crud = new Crud();
  TextEditingController code = new TextEditingController();

  var countcode;
  bool loading = true;

  geCountCodes() async {
    var responbebody = await crud.readDataWhere(linkCountcodes, widget.itemsid);
    countcode = int.parse(responbebody['count'].toString());
    print(countcode);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    geCountCodes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة كود'),
      ),
      body: loading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Form(
                key: formstate,
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      radius: 130.0,
                      lineWidth: 9.0,
                      percent: countcode / 100,
                      animationDuration: 1000,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text(
                            "الكمية المتوفرة",
                            style: TextStyle(fontSize: 13),
                          ),
                          new Text("$countcode"),
                        ],
                      ),
                      progressColor: maincolor,
                    ),
                    buildFormText("ادخل الكود هنا", code, "code"),
                    RaisedButton(
                      onPressed: () async {
                        var formdata = formstate.currentState;
                        if (formdata.validate()) {
                          showLoading(context);
                          var responsebody = await crud.writeData(
                              linkAddcodes, {
                            "code": code.text,
                            "itemid": widget.itemsid.toString()
                          });
                          if (responsebody['status'] == "success") {
                            Navigator.of(context).pop();
                          setState(() {
                              countcode++ ; 
                          });
                            showAlertOneChoose(context, "success", "مبروك",
                                "تم اضافة الكود بنجاح");
                          } else {
                            Navigator.of(context).pop();
                            showAlertOneChoose(context, "error", "فشل",
                                " لم بتم اضافة الكود قد يكون موجود مسبقا");
                          }
                        }
                      },
                      padding: EdgeInsets.symmetric(horizontal: 70),
                      color: maincolor,
                      textColor: Colors.white,
                      child: Text("اضافة كود"),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  buildFormText(String myhint, TextEditingController mycontorle, type) {
    return TextFormField(
      controller: mycontorle,
      validator: (val) {
        if (type == "code") {
          return validInput(val, 1, 100, "يكون الكود");
        }
        return null;
      },
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: myhint,
          prefixIcon: Icon(Icons.category)),
    );
  }
}

// CircularPercentIndicator(
//                 animation: true,
//                 radius: 130.0,
//                 lineWidth: 9.0,
//                 percent: countcode / 100,
//                 animationDuration: 1000,
//                 center: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     new Text(
//                       "الكمية المتوفرة",
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     new Text("$countcode"),
//                   ],
//                 ),
//                 progressColor: maincolor,
//               )

//   geCountCodes() async {
//   var responbebody =
//       await crud.readDataWhere(linkCountcodes, widget.items['items_id']);
//   countcode = int.parse(responbebody['count'].toString());
//   print(countcode);
//   setState(() {
//     loading = false;
//   });
// }

// percent_indicator: ^2.1.9
