import 'package:cached_network_image/cached_network_image.dart';
import 'package:untitled/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({super.key, required this.path});

  final String path;

  Future<String?> getFileUrl(String firebasePath) async {
    try {
      final downloadURL = await FirebaseStorage.instance.ref(firebasePath);
      return await downloadURL.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFileUrl(path),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
                return CachedNetworkImage(
                  key: UniqueKey(),
                    imageUrl: snapshot.data!,
                    fit: BoxFit.cover,
                );
          } else if (snapshot.error != null || snapshot.data == null) {
            return Image.asset('assets/logo.png', height: 50);
          }
        }
        return Image.asset('assets/logo.png', height: 50);
      },
    );
  }


}
