import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

// ignore: camel_case_types
class Uploading_img_on_server extends StatefulWidget {
  const Uploading_img_on_server({super.key});

  @override
  State<Uploading_img_on_server> createState() =>
      _Uploading_img_on_serverState();
}

File? image;
final _picker = ImagePicker();
bool showSpinner = false;

// ignore: camel_case_types
class _Uploading_img_on_serverState extends State<Uploading_img_on_server> {
  //get image from gallery only
  getImage() async {
    //final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 80);
    var pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {});
    } else {
      print("Image not Selected");
    }
  }

  // ignore: non_constant_identifier_names
  UploadImageOnServer() async {
    setState(() {
      showSpinner = true;
    });

    // ignore: unnecessary_new
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();
    var imgLength = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com/products');
    //MultipartRequest(API Method like get,post,put.. etc it must be string,"POST","GET", Uri)
    // ignore: unnecessary_new
    var request = new http.MultipartRequest("POST", uri);
    request.fields['title'] = "Static title";
    // ignore: unnecessary_new
    var multipart = new http.MultipartFile('image', stream, imgLength);
    request.files.add(multipart);
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        showSpinner = false;
      });
      print('Image Uploaded Succesfully');
    } else {
      setState(() {
        showSpinner = false;
      });
      print('Image is not uploaded');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Upload image to server",
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getImage();
                print("container 1");
              },
              child: Center(
                child: Container(
                  height: 400,
                  width: 400,
                  color: Colors.amber,
                  child: image == null
                      ? const Center(
                          child: Text("Pick Image",style: TextStyle(fontSize: 35),),
                        )
                      : Container(
                          child: Center(
                            child: Image.file(
                              File(image!.path).absolute,
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async{
                await UploadImageOnServer();
                print("container 2");
              },
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 60,
                  width: double.infinity,
                  child: const Center(
                      child: Text(
                    "Upload",
                    style: TextStyle(fontSize: 35),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
