import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groceries/const/app_color.dart';
import 'package:groceries/model/product_model.dart';
import 'package:groceries/screen/home_scren.dart';
import 'package:groceries/service/image_store.dart';
import 'package:groceries/service/product_add_service.dart';
import 'package:groceries/widget/text_field.dart';
import 'package:groceries/widget/title_text.dart';
import 'package:image_picker/image_picker.dart';

List<String> categoty_list = <String>[
  'Meat ',
  'Fish',
  'Fruits',
  'Vegetables',
  'Drinks and Cocktail',
  'others',
];

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPrductoState();
}

class _AddPrductoState extends ConsumerState<AddProductScreen> {
  XFile? image;
  List<XFile>? photos;
  final TextEditingController title = TextEditingController();

  final TextEditingController price = TextEditingController();
  final TextEditingController des = TextEditingController();
  String cata = 'others';

  final TextEditingController rating = TextEditingController();
  String dropdownValue = categoty_list.last;
  bool isImageLoading = false;
  Future<void> pickImage() async {
    setState(() {
      isImageLoading = true;
    });
    var media = ImagePicker();
    final List<XFile> pickedMedia = await media.pickMultipleMedia();

    setState(() {
      photos = pickedMedia;
      isImageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isImageLoading
                ? CircularProgressIndicator()
                : MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColor.primaryColor,
                    onPressed: () async {
                      setState(() {
                        isImageLoading = true;
                      });
                      List<File> photoList = photos?.map((xFile) => File(xFile.path)).toList() ?? [];

                      await ProductAddService().addProduct(
                        ProductModel(
                          name: title.text,
                          category: cata,
                          rating: rating.text,
                          price: price.text,
                          description: des.text,
                        ),
                      );
                      var photo = File(image!.path);
                      await IamgeStorage().storeImage(photo: photo, name: title.text);
                      await IamgeStorage().addPhotos(photos: photoList, name: title.text);
                      setState(() {
                        isImageLoading = false;
                      });

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                    child: titles(text: "add", color: AppColor.white),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(image: AssetImage('assets/images/1.jpeg'), fit: BoxFit.cover),
                        ),
                      )
                    : Container(
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.contain,
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 80,
                  child: TextButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final img = await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          image = img;
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Upload a photo',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          )
                        ],
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Material(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                shadowColor: AppColor.red,
                borderOnForeground: false,
                child: NormalTextField(
                  controller: title,
                  text: 'Title',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Material(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                shadowColor: AppColor.red,
                borderOnForeground: false,
                child: NormalTextField(
                  controller: price,
                  text: 'price',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Material(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                shadowColor: AppColor.red,
                borderOnForeground: false,
                child: NormalTextField(
                  line: 5,
                  controller: des,
                  text: 'description',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Material(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                shadowColor: AppColor.red,
                borderOnForeground: false,
                child: NormalTextField(
                  controller: rating,
                  text: 'rating',
                ),
              ),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              elevation: 16,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
              underline: Container(
                height: 4,
                color: Colors.blue,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                  cata = value;
                  print(cata);
                });
              },
              items: categoty_list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
            photos == null
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        for (int i = 0; i < photos!.length; i++)
                          Container(
                              width: 120,
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(photos![i].path),
                                  fit: BoxFit.cover,
                                ),
                              )),
                      ],
                    ),
                  ),
            isImageLoading
                ? CircularProgressIndicator()
                : MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: AppColor.primaryColor,
                    onPressed: () {
                      pickImage();
                    },
                    child: titles(
                      text: "Add Images",
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
