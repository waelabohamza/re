import 'package:adminyaser/const.dart';
import 'package:adminyaser/linkapi.dart';
import 'package:adminyaser/pages/codes/addcodes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemsList extends StatefulWidget {
  final items;
  ItemsList({Key key, this.items}) : super(key: key);
  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                        "$linkupload/items/${widget.items['items_image']}",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
              Expanded(
                  flex: 2,
                  child: ListTile(
                      title: Text("${widget.items['items_name']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.items['subcategories_name']}"),
                          Text(
                            "${widget.items['categories_name']}",
                            style: TextStyle(color: maincolor),
                          ),
                        ],
                      ),
                      trailing: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                  return AddCodes(
                                      itemsid: widget.items['items_id']);
                                }));
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  color: maincolor,
                                  child: Text(
                                    "اضافة كود",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
