import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/widgets/drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool loading = false;
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    final imagePicker = ImagePicker();
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0).add(
          const EdgeInsets.only(top: 20.0),
        ),
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                border: Border.all(
                  width: 2,
                  color: const Color.fromARGB(255, 224, 224, 224),
                ),
              ),
              width: 150,
              height: 150,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/images/profile.png'),
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    if (imageFile != null)
                      loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: Image.file(
                                File(imageFile!.path),
                                repeat: ImageRepeat.noRepeat,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                isAntiAlias: true,
                              ),
                            ),
                    Positioned(
                      bottom: 7,
                      right: 7,
                      child: GestureDetector(
                        onTap: () async {
                          final image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            loading = true;
                          });

                          if (image != null) {
                            setState(() {
                              imageFile = image;
                            });
                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              setState(() {
                                loading = false;
                              });
                            });
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          // color: Colors.grey,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          const Align(
            child: Text(
              'Mark Zuckerberg',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const Align(
            child: Text(
              'Hello wasd asdas',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          TextFormField(
            initialValue: 'test@gmail.com',
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          const SizedBox(height: 15.0),
          TextFormField(
            initialValue: 'test@gmail.com',
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('SAVE'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
