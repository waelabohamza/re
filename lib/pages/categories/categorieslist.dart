import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/categories/categories.dart';
import 'package:adminyaser/pages/categories/editcategories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget{
  final categories;
  CategoriesList({Key key, this.categories}) : super(key: key);
  @override  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: (){
         Navigator.of(context).push(MaterialPageRoute(builder: (context){
               return  EditCategories(categories:widget.categories)  ; 
         })) ; 
      },
      child: Card(
        child: Container(
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    height: 100,
                    imageUrl:
                        "$linkupload/categories/${widget.categories['categories_image']}",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
              Expanded(
                  flex: 2,
                  child: ListTile(
                    title: Text("${widget.categories['categories_name']}"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
