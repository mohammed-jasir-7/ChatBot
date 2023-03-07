import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  // select image
  Future<dynamic> selectImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["jpg"]);
    log("selectfile file  function $result");
    return result;
  }

  //update to database
  Future<bool> uploadFile(FilePickerResult image) async {
    final imagePath = "${image.paths.first}";
    final File file = File(imagePath);
    final path = currentUser;
    final ref = FirebaseStorage.instance.ref().child(path).child(path);
    bool isUploaded = false;
    try {
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.whenComplete(
        () async {
          final url = await ref.getDownloadURL();
          FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser)
              .update({"photo": url});
          isUploaded = true;
        },
      );
    } on FirebaseException catch (e) {
      log("uploadfile function error ${e.code}");
      isUploaded = false;
    }

    log("image uploaded");
    return isUploaded;
  }
}
