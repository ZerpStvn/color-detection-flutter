import 'package:colorpick/page/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'colordetect.dart'; // Adjust the import path as needed

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImagePicker picker = ImagePicker();
  XFile? imagefile;

  Future<void> getimage(bool iscamera) async {
    try {
      XFile? fileimagefromdevice = await picker.pickImage(
          source: iscamera ? ImageSource.camera : ImageSource.gallery);

      if (fileimagefromdevice != null) {
        setState(() {
          imagefile = fileimagefromdevice;
          debugPrint("$fileimagefromdevice");
        });
      }
    } catch (error) {
      debugPrint("No image Selected $error");
    }
  }

  Future<void> handlegetimage(bool iscamera) async {
    await getimage(iscamera);
    if (imagefile != null && mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ColorDetectresult(imagepicked: imagefile!)));
    }
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
                    handlegetimage(true);
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
                    handlegetimage(false);
                  },
                  child: const Text(
                    "Upload Image",
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CameraDetectionPage()));
                  },
                  child: const Text(
                    "Object Detect",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
