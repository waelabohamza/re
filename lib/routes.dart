import 'package:adminyaser/pages/auth/login.dart';
import 'package:adminyaser/pages/categories/addcategories.dart';
import 'package:adminyaser/pages/categories/categories.dart';
import 'package:adminyaser/pages/home/home.dart';
import 'package:adminyaser/pages/items/additems.dart';
import 'package:adminyaser/pages/items/items.dart';
import 'package:adminyaser/pages/subcategories/addsubcategories.dart';
import 'package:adminyaser/pages/subcategories/subcategories.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "home": (context) => Home(),
  "login": (context) => Login(),
  "categories": (context) => Categories(),
  "addcategories": (context) => AddCategories(),
  "subcategories": (context) => SubCategories(),
  "addsubcategories": (context) => AddSubCategories(),
  "items": (context) => Items(),
  "additems": (context) => AddItems()
  // "addsubcategories" : (context) =>
};
