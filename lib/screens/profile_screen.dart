import 'dart:io';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/providers/auth_provider.dart';
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
  bool isEdit = false;
  bool imageError = false;
  XFile? imageFile;
  Map<String, dynamic> userInfo = {};
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      final user = Provider.of<AuthProvider>(context).user;

      if (user != null) {
        userInfo['photoUrl'] = user!.photoURL;
        userInfo['email'] = user!.email;
        _phoneNumberController.text = user!.phoneNumber ?? '--';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    print('>>>>>>>>>>>>>>>>>>>>${auth.user.providerData[0].providerId}');
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            alignment: Alignment.center,
            child: !isEdit
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_phoneNumberController.text == '--') {
                          _phoneNumberController.text = '';
                        }
                        isEdit = !isEdit;
                      });
                    },
                    child: const Tooltip(
                      message: 'Edit',
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _phoneNumberController.text =
                            auth.user!.phoneNumber ?? '--';
                        imageFile = null;
                        isEdit = !isEdit;
                        loading = true;

                        Future.delayed(const Duration(milliseconds: 150), () {
                          setState(() {
                            loading = false;
                          });
                        });
                      });
                    },
                    child: const Tooltip(
                      message: 'Cancel',
                      child: Icon(
                        Icons.do_not_disturb_alt_sharp,
                        size: 20,
                        semanticLabel: 'Cancel',
                      ),
                    ),
                  ),
          )
        ],
      ),
      body: LoaderOverlay(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(10.0).add(
              const EdgeInsets.only(top: 20.0),
            ),
            children: [
              Align(
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 5),
                  switchInCurve: Curves.linearToEaseOut,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      border: Border.all(
                        width: 2,
                        color: imageError
                            ? Colors.red
                            : const Color.fromARGB(255, 224, 224, 224),
                      ),
                    ),
                    width: 150,
                    height: 150,
                    child: CircleAvatar(
                      radius: 60,
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.antiAlias,
                        children: [
                          loading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: imageFile != null
                                      ? Image.file(
                                          File(imageFile!.path),
                                          repeat: ImageRepeat.noRepeat,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          isAntiAlias: true,
                                        )
                                      : auth.user?.photoURL != null
                                          ? Image.network(
                                              auth.user?.photoURL,
                                              repeat: ImageRepeat.noRepeat,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              isAntiAlias: true,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/profile.png',
                                                  repeat: ImageRepeat.noRepeat,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  isAntiAlias: true,
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              'assets/images/profile.png',
                                              repeat: ImageRepeat.noRepeat,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              isAntiAlias: true,
                                            ),
                                ),
                          if (isEdit)
                            Positioned(
                              bottom: 7,
                              right: 7,
                              child: GestureDetector(
                                onTap: () async {
                                  final image = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  setState(() {
                                    loading = true;
                                  });

                                  if (image != null) {
                                    setState(() {
                                      imageError = false;
                                      imageFile = image;
                                    });
                                    await Future.delayed(
                                        const Duration(seconds: 1), () {
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
                            ),
                        ],
                      ),
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
                enabled: isEdit,
                initialValue: userInfo['email'],
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: isEdit,
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              const SizedBox(height: 15.0),
              if (isEdit)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('SAVE'),
                    onPressed: () async {
                      // if (auth.user!.photoURL == null && imageFile == null) {
                      //   print('WOWOWOW');
                      //   setState(() {
                      //     imageError = true;
                      //   });
                      //   return;
                      // }

                      // context.loaderOverlay.show();
                      // final image = imageFile?.path;

                      // bool isSuccess = await auth.updateCredential(
                      //   photo: image != null ? File(image) : null,
                      //   phoneNumber: _phoneNumberController.text,
                      // );

                      // if (isSuccess) {
                      //   context.loaderOverlay.hide();
                      // }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
