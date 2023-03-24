import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
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
  Future<dynamic> uploadFile(FilePickerResult image, String path,
      String collectionName, String? groupId) async {
    final imagePath = "${image.paths.first}";
    final File file = File(imagePath);

    final ref = FirebaseStorage.instance.ref().child(path).child(path);
    String? isUploaded;
    try {
      UploadTask uploadTask = ref.putFile(file);
      if (collectionName == "users") {
        uploadTask.whenComplete(
          () async {
            final url = await ref.getDownloadURL();
            FirebaseFirestore.instance
                .collection(collectionName)
                .doc(currentUser)
                .update({"photo": url});
          },
        );
      } else if (groupId != null) {
        uploadTask.whenComplete(
          () async {
            final url = await ref.getDownloadURL();
            FirebaseFirestore.instance
                .collection(collectionName)
                .doc(groupId)
                .update({"image": url});
          },
        );
      }
    } on FirebaseException catch (e) {
      log("uploadfile function error ${e.code}");
      isUploaded = e.code;
    }

    log("image uploaded");
    return isUploaded;
  }
}
