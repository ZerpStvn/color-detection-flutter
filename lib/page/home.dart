import 'package:colorpick/page/colordetect.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? imagefromgallery;
  ImagePicker picker = ImagePicker();
  XFile? imagefromcamera;

  Future getimageGallery() async {
    try {
      XFile? fileimagefromgallery =
          await picker.pickImage(source: ImageSource.gallery);

      if (imagefromgallery == null) {
        setState(() {
          imagefromgallery = fileimagefromgallery;
          debugPrint("$imagefromgallery");
        });
      }
    } catch (error) {
      debugPrint("No image Selected $error");
    }
  }

  Future getimageCamera() async {
    try {
      XFile? fileimagefromcamera =
          await picker.pickImage(source: ImageSource.camera);

      if (imagefromcamera == null) {
        setState(() {
          imagefromcamera = fileimagefromcamera;
          debugPrint("$imagefromcamera");
        });
      }
    } catch (error) {
      debugPrint("No image Selected $error");
    }
  }

  void handlegetimagefromcamera() {
    getimageCamera().then((value) {
      if (imagefromcamera != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ColorDetectresult(imagepicked: imagefromcamera!)));
      }
    });
  }

  void handlegetimagefromgallery() {
    getimageGallery().then((value) {
      if (imagefromgallery != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ColorDetectresult(imagepicked: imagefromgallery!)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    handlegetimagefromcamera();
                  },
                  child: const Text(
                    "Take a Photo",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 240,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    handlegetimagefromgallery();
                  },
                  child: const Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
