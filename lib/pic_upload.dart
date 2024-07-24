import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'dart:convert';

class UploadPic extends StatefulWidget {
  UploadPic({Key? key,}) : super(key: key);


  @override
  _UploadPicState createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPic> {


  String? panImg;
  String? aadharImg;

//  var selectedDate;
  late bool isLoading;

  File? imgFile;
  final imgPicker = ImagePicker();
  final imgPicker1 = ImagePicker();
  File? imgFile1;
  final imgPicker2 = ImagePicker();
  File? imgFile2;
  int graphoption = 0;
  var file;

  void initState() {
    super.initState();

  }


  // void showpic(String pic, String titlemsg) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: new Text(titlemsg),
  //         content:
  //         Image.file(
  //           File(
  //               pic
  //           ),
  //         ),
  //         actions: <Widget>[
  //           new TextButton(
  //             child: new Text("OK"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Upload Images"),),
      body:
      Padding(
        padding:  EdgeInsets.only(top: 80),
        child: Center(
          child: ShowingText(

            browseText: "Browse",

            browseImages: () {
              setState(() {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) =>
                      _buildBottomSheetForImagePicker()),
                );
              });
            },
            fadeInImages: imgFile == null
                ? Container(
              color: Colors.green.withOpacity(0.5),
            )
                : GestureDetector(
              onTap: () {
                //showpic(imgFile!.path, "Pan Card");

                ///call function
              },
              child: Container(
                color: Colors.green.withOpacity(0.5),
                child: Image.file(
                  File(
                    imgFile!.path,
                  ),
                  height: 30,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),),

          ),
        ),
      ),

    );
  }

  Widget _buildBottomSheetForImagePicker() {
    return Container(
      height: 100,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Select Document",),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  openCamera();
                },
                icon: Icon(
                  Icons.camera_alt_outlined,

                ),
                label: Text("Camera",),
              ),
              TextButton.icon(
                onPressed: () {
                  openGallery();
                },
                icon: Icon(
                  Icons.image,
                ),
                label: Text("Gallery",),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
    });
    Navigator.of(context).pop();
    Base641(imgFile);
  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    Navigator.of(context).pop();
    Base641(imgFile);
  }

  Base641(File? imgFile) {
    final bytes = Io.File(imgFile!.path).readAsBytesSync();
    panImg = base64Encode(bytes);
    print(panImg.toString());
  }

}



class ShowingText extends StatelessWidget {


  final String browseText;
  final String? errtxt;
  Widget fadeInImages;
  Function()? browseImages;
  ShowingText(
      {

        required this.browseText,
        required this.fadeInImages,
        this.browseImages,  this.errtxt})
      : super();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10,bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.1,
                      ),
                    ),
                    height: 500,
                    width: 390,
                    child: ClipRRect(child: fadeInImages),
                  ),
                ],
              ),
              Container(
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                      errorText: errtxt,


                      contentPadding: EdgeInsets.only(left: 5, right: 5),
                      border: OutlineInputBorder(
                        borderSide:  BorderSide(),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 1.0),
                        child: GestureDetector(
                          onTap: browseImages,
                          child: Container(
                            color: Colors.grey,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 8, left: 5, right: 5),
                              child: Text(browseText),
                            ),
                          ),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}