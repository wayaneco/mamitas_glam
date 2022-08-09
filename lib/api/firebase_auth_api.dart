import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

const COLLECTION_USER_DATA = 'users-data';
const COLLECTION_PROFILE = 'profile';

Future signUpWithEmailAndPassword({
  required email,
  required password,
}) async {
  try {
    UserCredential user = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return {
      'status': 200,
      'data': user,
    };
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return {
        'status': 400,
        'type': 'password',
        'message': 'The password provided is too weak.',
      };
    } else if (e.code == 'email-already-in-use') {
      return {
        'status': 400,
        'type': 'email',
        'message': 'The account already exists for that email.',
      };
    } else if (e.code == 'invalid-email') {
      return {
        'status': 400,
        'type': 'email',
        'message': 'The email is not valid.',
      };
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future signInWithEmailAndPassword({
  email,
  password,
}) async {
  try {
    UserCredential user = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return {
      'status': 200,
      'data': user,
    };
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return {
        'status': 400,
        'type': 'email',
        'message': 'The email is not yet registered.',
      };
    } else if (e.code == 'wrong-password') {
      return {
        'status': 400,
        'type': 'password',
        'message': 'Wrong password.',
      };
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future signOut() {
  return auth.signOut().then((_) => true).catchError((_) => false);
}

Future updateCredentials({
  photo,
  phoneNumber,
  userCred,
}) async {
  // if (photo != null) {
  //   return storage
  //       .ref('$COLLECTION_PROFILE/${userCred!.uid}')
  //       .child('aw')
  //       .putFile(photo)
  //       .then(
  //     (TaskSnapshot task) async {
  //       final url = await task.ref.getDownloadURL();
  //       await auth.currentUser!.updatePhoneNumber(phoneNumber);
  //       final response = await Future.wait([
  //         auth.currentUser!.updatePhotoURL(url),
  //       ]);

  //       print(response);

  //       return true;
  //     },
  //   ).catchError(
  //     (_) => false,
  //   );
  // } else if (phoneNumber != null) {
  return await auth.currentUser!
      .reauthenticateWithCredential(AuthCredential(
        providerId: userCred!.providerData[0].providerId,
        signInMethod: EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD,
      ))
      .then((value) => print(value));
  // }
}
