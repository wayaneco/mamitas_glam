import 'package:flutter/material.dart';

import '../api/firebase_auth_api.dart' as api;

class AuthProvider with ChangeNotifier {
  var userCredential;
  var _error;
  bool _isLoading = true;

  Future registerAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required loaderOverlay,
  }) async {
    try {
      loaderOverlay.show();
      setLoading(true);
      final response = await api.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response['status'] == 200) {
        loaderOverlay.hide();
        setLoading(false);
        return true;
      } else if (response['status'] == 400) {
        _error = response;

        loaderOverlay.hide();
        setLoading(false);
        return false;
      }
    } catch (error) {
      loaderOverlay.hide();
      setLoading(false);
      return false;
    }
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setUser(user) {
    userCredential = user;
    notifyListeners();
  }

  Future<bool> logOut({
    required loaderOverlay,
  }) async {
    loaderOverlay.show();
    return await Future.delayed(
        const Duration(
          seconds: 2,
        ), () async {
      try {
        setLoading(true);
        final isSuccess = await api.signOut();
        loaderOverlay.hide();
        if (isSuccess) {
          setLoading(false);
          return true;
        } else {
          setLoading(false);
          return false;
        }
      } catch (error) {
        setLoading(false);
        return false;
      }
    });
  }

  Future login({
    required String email,
    required String password,
    required loaderOverlay,
  }) async {
    try {
      setLoading(true);
      loaderOverlay.show();

      Map<String, dynamic> response = await api.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response['status'] == 200) {
        print(response['data'].user);
        userCredential = response['data'].user;
        setLoading(false);
        loaderOverlay.hide();
        notifyListeners();
        return true;
      } else if (response['status'] == 400) {
        _error = response;
        setLoading(false);
        loaderOverlay.hide();
        notifyListeners();
        return false;
      }
    } catch (error) {
      loaderOverlay.hide();
      setLoading(false);
      return false;
    }
  }

  Future updateCredential({photo, phoneNumber}) async {
    return await api.updateCredentials(
      photo: photo,
      phoneNumber: phoneNumber,
      userCred: userCredential,
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  get user => userCredential;
  get error => _error;
  get isLoading => _isLoading;
}
