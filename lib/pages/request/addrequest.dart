// import 'package:adminyaser/const.dart';
// import 'package:adminyaser/linkapi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

String basicAuth = 'Basic ' +
    base64Encode(utf8.encode(
        'TalabGoUser@58421710942258459:TalabGoPassword@58421710942258459'));
Map<String, String> myheaders = {
  // 'content-type': 'application/json',
  // 'accept': 'application/json',
  'authorization': basicAuth
};

Future addRequestWithImageOne(url, data, File image) async {
  var stream = new http.ByteStream(image.openRead());
  stream.cast();
  var length = await image.length();
  var uri = Uri.parse(url);
  var request = new http.MultipartRequest("POST", uri);
  request.headers.addAll(myheaders);
  var multipartFile = new http.MultipartFile("file", stream, length,
      filename: basename(image.path));
  // add Data to request
  data.forEach((key, value) {
    request.fields[key] = value;
  });
  // add Data to request
  request.files.add(multipartFile);
  // Send Request
  var myrequest = await request.send();
  // For get Response Body
  var response = await http.Response.fromStream(myrequest);
  if (myrequest.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body);
  } else {
    print(response.body);
    return jsonDecode(response.body);
  }
}

Future addRequestAndImageTwo(
    String url, Map data, File image, File imagetwo) async {
  var stream = new http.ByteStream(image.openRead());
  stream.cast();
  var streamtwo = new http.ByteStream(imagetwo.openRead());
  stream.cast();
  var length = await image.length();
  var lengthtwo = await imagetwo.length();
  var uri = Uri.parse(url);
  var request = new http.MultipartRequest("POST", uri);
  request.headers.addAll(myheaders);
  var multipartFile = new http.MultipartFile("file", stream, length,
      filename: basename(image.path));
  var multipartFileTwo = new http.MultipartFile("filetwo", streamtwo, lengthtwo,
      filename: basename(imagetwo.path));
  // add Data to request
  data.forEach((key, value) {
    request.fields[key] = value;
  });
  // add Data to request
  request.files.add(multipartFile);
  request.files.add(multipartFileTwo);
  // Send Request
  var myrequest = await request.send();
  // For get Response Body
  var response = await http.Response.fromStream(myrequest);
  if (myrequest.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body);
  } else {
    print(response.body);
    return jsonDecode(response.body);
  }
}
