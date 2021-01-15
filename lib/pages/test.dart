import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Test extends StatefulWidget {
  Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  ScrollController _controller;
  var message;
  List users = [];
  bool loading = true;
  int b = 0;
  getUsers(int a) async {
    setState(() {
      loading = true  ; 
    });
    var url = "http://10.0.2.2:8080/food/users/users.php?page=$a";
    await Future.delayed(Duration(seconds: 2)) ; 
    var response = await http.get(url);
    var responsebody = jsonDecode(response.body);
    for (int i =  0; i < responsebody.length; i++)
      users.add(responsebody[i]);
    setState(() {
      loading = false;
    });
    print(users);
  }

  @override
  void dispose() {
    _controller.dispose();
    
    super.dispose();
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      print(_controller.offset);
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print("maxbottom");
        
          b = b + 2;
       
        getUsers(b);
      }
      if (_controller.offset <= _controller.position.minScrollExtent) {
        setState(() {
          
        });
      }
    });
    getUsers(b);
    super.initState();
  }

 
   Future<void> onRefreshNow() async {
        users = [] ;
        b = 0 ; 
        await getUsers(b) ; 
     
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Title'),
        ),
        body:  Stack(children: [ 
          RefreshIndicator(
            child: ListView.builder(
            controller: _controller,
            itemCount: users.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                  color: i % 2 == 0 ? Colors.red : Colors.blue,
                  height: 460,
                  child: Text(
                    "${users[i]['username']}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700),
                  ));
            },
        ),
        onRefresh: onRefreshNow,
          ) , 
         if (loading == true ) Center(child: CircularProgressIndicator(backgroundColor: Colors.white,)) 
        ],)
        );
  }
}
/*
<?php

  include "../connect.php" ;


  if ( isset($_POST['userid']) ) {
     $userid = $_POST['userid'] ;
     $where  = "WHERE  `user_id` =  $userid " ;
  }else {
    $where  = " WHERE user_id != 1 " ;
  }

  $page = $_GET['page'] ;


   $stmt = $con->prepare("SELECT   * FROM `users`  $where LIMIT $page , 2  ");

   $stmt->execute();

   $users = $stmt->fetchall(PDO::FETCH_ASSOC);

   echo json_encode($users) ;



?>


*/