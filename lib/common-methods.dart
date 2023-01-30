import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String msg,String? qr){
  if(qr == "qr"){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }else{
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}
showImageDetail(context, image) {
  print("image path show imaedetail : $image");
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return GestureDetector(
        child: Center(
          child: Hero(
            tag: image,
            /*child: image.contains('https')
                ?  ExtendedImage.network(
              image,
              fit: BoxFit.contain,
              cache: false,
              mode: ExtendedImageMode.gesture,
              enableSlideOutPage: true,
              filterQuality: FilterQuality.high,
              initGestureConfigHandler: (state) {
                return GestureConfig(
                  initialScale: 1.0,
                  minScale: 1.0,
                  animationMinScale: 0.9,
                  maxScale: 10.0,
                  animationMaxScale: 11,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  inPageView: true,
                  cacheGesture: false,
                  initialAlignment: InitialAlignment.center,
                );
              },
            )
                : ExtendedImage.file(
              io.File(image),
              fit: BoxFit.contain,
              mode: ExtendedImageMode.gesture,
              enableSlideOutPage: true,
              filterQuality: FilterQuality.high,
              initGestureConfigHandler: (state) {
                return GestureConfig(
                  initialScale: 1.0,
                  minScale: 1.0,
                  animationMinScale: 0.9,
                  maxScale: 10.0,
                  animationMaxScale: 11,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  inPageView: true,
                  cacheGesture: false,
                  initialAlignment: InitialAlignment.center,
                );
              },
            ),*/

            child: imageWidget(image) ,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
  );
}
imageWidget(image) {
  if(image.contains('assets')){
    return ExtendedImage.asset(
      image,
      fit: BoxFit.contain,

      mode: ExtendedImageMode.gesture,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.high,
      initGestureConfigHandler: (state) {
        return GestureConfig(
          initialScale: 1.0,
          minScale: 1.0,
          animationMinScale: 0.9,
          maxScale: 10.0,
          animationMaxScale: 11,
          speed: 1.0,
          inertialSpeed: 100.0,
          inPageView: true,
          cacheGesture: false,
          initialAlignment: InitialAlignment.center,
        );
      },
    );
  }else if(image.contains('https')){
    return ExtendedImage.network(
      image,
      fit: BoxFit.contain,
      cache: false,
      mode: ExtendedImageMode.gesture,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.high,
      initGestureConfigHandler: (state) {
        return GestureConfig(
          initialScale: 1.0,
          minScale: 1.0,
          animationMinScale: 0.9,
          maxScale: 10.0,
          animationMaxScale: 11,
          speed: 1.0,
          inertialSpeed: 100.0,
          inPageView: true,
          cacheGesture: false,
          initialAlignment: InitialAlignment.center,
        );
      },
    );
  }else{
   return ExtendedImage.file(
      io.File(image),
      fit: BoxFit.contain,
      mode: ExtendedImageMode.gesture,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.high,
      initGestureConfigHandler: (state) {
        return GestureConfig(
          initialScale: 1.0,
          minScale: 1.0,
          animationMinScale: 0.9,
          maxScale: 10.0,
          animationMaxScale: 11,
          speed: 1.0,
          inertialSpeed: 100.0,
          inPageView: true,
          cacheGesture: false,
          initialAlignment: InitialAlignment.center,
        );
      },
    );
  }

}


io.File? imageFile;
var fileExtensionArray = ['jpg','jpeg','png'];
/// Get from gallery
Future<PlatformFile?> getFromGallery() async {




  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf','jpg','jpeg','png']);

  if (result != null) {
    PlatformFile file = result.files.first;

    //final newFile = saveFilePermenantly(file);
    /* if (file != null) {
      print('extension >> ${file.extension}');
      imageFile = File(file.path!);
      return imageFile;
    }*/
    return file;
  }

  return null;

}

/// Get from camera
Future<io.File?> getFromCamera() async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    imageFile = io.File(pickedFile.path);
    return imageFile;
  }
  return null;
}

/*
uploadDesktopImage() async {
  profileController.isCaptured.value = false;
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

  if (result != null) {
    PlatformFile file = result.files.first;
    imageFile = file as File?;
    profileController.profileImage.value = imageFile!.path;
    profileController.isCaptured.value = true;
    profileController.uploadProfileImage(imageFile!);

  } else {
    // User canceled the picker
  }
}*/


Future<io.File> saveFilePermenantly(PlatformFile file) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final newFile =  io.File('${appStorage.path} / ${file.name}');
  return io.File(file.path!).copy(newFile.path);
}




Future<Object?> buildShowGeneralDialog(context, optionTitle) {
  return showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.width / 2,
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    optionTitle,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          //Get.back(result: 'camera');
                          Navigator.of(context).pop('camera');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.transparent),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const Text("Camera"),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          //Get.back(result: 'gallery');
                          Navigator.of(context).pop('gallery');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.transparent),
                              child: const Icon(
                                Icons.insert_photo_rounded,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const Text("Gallery"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
  );
}

