import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Model/snapshot_handler.dart';
import '../../QRScreens/image_picker.dart';
import '../../coreRes/color_handler.dart';
import '../../coreRes/font-handler.dart';
import '../../coreRes/icon_handler.dart';

class VirtualProfileScreen extends StatefulWidget {
  const VirtualProfileScreen({super.key});
  static var croppedPath;

  @override
  State<VirtualProfileScreen> createState() => _VirtualProfileScreenState();
}

class _VirtualProfileScreenState extends State<VirtualProfileScreen> {
  bool EditPress = false;
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final controller4 = TextEditingController();
  final controller5 = TextEditingController();
  final controller6 = TextEditingController();

  String title = "John Grandson";
  String subtitle = "Real Estate Broker";
  String about =
      "This package is also a submission to Flutter Create contest. The basic rule of this contest is to measure the total Dart file size less or equal 5KB.After unzipping the compressed file, run following command to update dependencies";
  String twitter = '';
  String linkedin = '';
  String website = '';
  String CorporateLogo =
      'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?q=80&w=464&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  String Userimg =
      "https://cdn.vectorstock.com/i/1000x1000/13/68/person-gray-photo-placeholder-man-vector-23511368.webp";
  File? image;
  final User? user = SnapShotHandler.CurrentUser();
  CollectionReference User_profile =
      FirebaseFirestore.instance.collection("User_Profiles");
  CollectionReference Virtual_Profile =
      FirebaseFirestore.instance.collection("Virtual_Profile");

  Future<void> SaveInfo() async {
    try {
      var imageName = user!.uid.toString();
      var storageRef = FirebaseStorage.instance
          .ref()
          .child('VirtualProfileCompanyLogos/$imageName.jpg');
      image = File(VirtualProfileScreen.croppedPath);
      var uploadTask = storageRef.putFile(image!);
      await uploadTask;
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      var data = {
        "CorporateLogo": downloadUrl.toString(),
        "title": title,
        "subtitle": subtitle,
        "about": about,
        "twitter": twitter,
        "Website": website,
        "Linkedin": linkedin
      };

      SnapShotHandler.SetData(Virtual_Profile.doc(user?.uid), data);
    } catch (e) {
      print("Error getting document: $e");
    }
  }

  Future<void> ImageHandler() async {
    if (VirtualProfileScreen.croppedPath != null) {
      image = File(VirtualProfileScreen.croppedPath);
    }

    await User_profile.doc(user?.uid).get().then(
      (DocumentSnapshot doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            Userimg = data['image'].toString();
          });
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );

    await Virtual_Profile.doc(user?.uid).get().then(
      (DocumentSnapshot doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            CorporateLogo = data['CorporateLogo'].toString();
            title = data['title'].toString();
            subtitle = data['subtitle'].toString();
            about = data['about'].toString();
            twitter = data['twitter'].toString();
            linkedin = data['Linkedin'].toString();
            website = data['website'].toString();
          });
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {
    try {
      ImageHandler();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorHandler.bgColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Stack(
          children: [
            Column(
              children: [
                Stack(children: [
                  SizedBox(
                    height: 280.h,
                    width: 460.w,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: image != null
                            ? Image.file(image!)
                            : Image.network(
                                CorporateLogo,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 26.w,
                      height: 26.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.sp),
                          color: Colors.yellow),
                      child: IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ImagePicker_(
                                        isVirtualProfile: true,
                                      )));
                        },
                        icon: const Icon(
                          IconHandler.alternate_pencil,
                          color: ColorHandler.bgColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 20.h,
                ),
                Stack(children: [
                  SizedBox(
                      height: 300.h,
                      width: 460.w,
                      child: Card(
                        elevation: 6.0,
                        color: Colors.amber,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: EditPress
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: TextField(
                                      controller: controller1,
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      selectionHeightStyle:
                                          BoxHeightStyle.includeLineSpacingTop,
                                      decoration: const InputDecoration(
                                          hintText: "ex. John Grandson",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: TextField(
                                      controller: controller2,
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      decoration: const InputDecoration(
                                          hintText: "ex. Real Estate Broker",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 120,
                                    child: TextField(
                                      controller: controller3,
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      maxLines: 5,
                                      decoration: const InputDecoration(
                                          hintText:
                                              "ex. This package is also a submission to Flutter Create contest. ",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FontHandler(
                                    title,
                                    color: ColorHandler.bgColor,
                                    textAlign: TextAlign.center,
                                    fontsize: 40.sp,
                                    fontweight: FontWeight.bold,
                                  ),
                                  FontHandler(subtitle,
                                      color: ColorHandler.bgColor,
                                      textAlign: TextAlign.center,
                                      fontsize: 25.sp,
                                      fontweight: FontWeight.bold),
                                  SizedBox(
                                    height: 125,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      child: Text(
                                        about,
                                        maxLines: 6,
                                        softWrap: true,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: ColorHandler.bgColor),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 26.w,
                      height: 26.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.sp),
                          color: Colors.yellow),
                      child: IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 0),
                        onPressed: () {
                          setState(() {
                            controller1.text == ""
                                ? title = title
                                : title = controller1.text;
                            controller2.text == ""
                                ? subtitle = subtitle
                                : subtitle = controller2.text;
                            controller3.text == ""
                                ? about = about
                                : about = controller3.text;
                            controller4.text == ""
                                ? twitter = twitter
                                : twitter = controller4.text;
                            controller5.text == ""
                                ? linkedin = linkedin
                                : linkedin = controller5.text;
                            controller6.text == ""
                                ? website = website
                                : website = controller6.text;

                            EditPress
                                ? (EditPress = false, SaveInfo())
                                : EditPress = true;
                          });
                        },
                        icon: Icon(
                          EditPress
                              ? IconHandler.submit
                              : IconHandler.alternate_pencil,
                          color: ColorHandler.bgColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ]),
                Column(
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),
                    SeeMore(
                      icon: IconHandler.twitter,
                      text: "Twitter",
                      onPressed: () {},
                      EditPress: EditPress,
                      controller: controller4,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SeeMore(
                      icon: IconHandler.linkedin,
                      text: "Linkedin",
                      onPressed: () {},
                      EditPress: EditPress,
                      controller: controller5,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SeeMore(
                      icon: IconHandler.earth,
                      text: "Website",
                      onPressed: () {},
                      EditPress: EditPress,
                      controller: controller6,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: height.sp / 2.sp - 210.sp),
              alignment: AlignmentDirectional.center,
              child: Stack(children: [
                Container(
                  padding: EdgeInsets.all(8.sp),
                  width: 180.w,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: ColorHandler.normalFont,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(Userimg),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class SeeMore extends StatelessWidget {
  const SeeMore({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.EditPress,
    required this.controller,
  });
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool EditPress;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 60.h,
        width: 400.w,
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        decoration: BoxDecoration(
          color: ColorHandler.normalFont.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.sp,
              color: Colors.yellow,
            ),
            EditPress
                ? SizedBox(
                    height: 50,
                    width: 240,
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      selectionHeightStyle:
                          BoxHeightStyle.includeLineSpacingTop,
                      decoration: InputDecoration(
                        hintText: text,
                      ),
                    ),
                  )
                : Center(
                    widthFactor: 2.sp,
                    child: FontHandler(
                      text,
                      color: ColorHandler.normalFont,
                      textAlign: TextAlign.center,
                      fontweight: FontWeight.w800,
                      fontsize: 20.sp,
                    )),
          ],
        ),
      ),
    );
  }
}
