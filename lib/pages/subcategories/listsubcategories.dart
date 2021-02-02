import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/subcategories/editsubcategories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SubCategoriesList extends StatefulWidget {
  final subcategories;
  SubCategoriesList({Key key, this.subcategories}) : super(key: key);
  @override
  _SubCategoriesListState createState() => _SubCategoriesListState();
}

class _SubCategoriesListState extends State<SubCategoriesList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
               return EditSubCategories(subcategories: widget.subcategories) ; 
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
                        "$linkupload/subcategories/${widget.subcategories['subcategories_image']}",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
              Expanded(
                  flex: 2,
                  child: ListTile(
                    title: Text("${widget.subcategories['subcategories_name']}"),
                    subtitle: Text("${widget.subcategories['categories_name']}"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
