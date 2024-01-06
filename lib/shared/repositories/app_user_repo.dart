import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:su_thesis_book/shared/models/models.dart';
import 'package:su_thesis_book/utils/utils.dart';

export 'package:firebase_auth/firebase_auth.dart'
    show AuthCredential, User, UserCredential;

// extension UserExt on User? {
//   Future<(String?, AppUser)> toAppUser() async => this == null
//       ? (null, AppUser.unauthenticated)
//       : await AppUserRepo().read(this!.uid);
// }

class AppUserRepo implements CRUD<AppUser> {
  // AppUserRepo() {
  //   stream.first.then((_) => null);
  // }
  //-- Config
  // final _controller = StreamController<AppUser>.broadcast();
  final _cacheDesignations = const Cache<List<String>>('designations');
  final _cacheDepartments = const Cache<List<String>>('departments');
  final _cache = const Cache<AppUser>('appUser');
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref('users');
  final _storage = FirebaseStorage.instance.ref('photos');
  final _errorMsgCreate = "Couldn't create the User!";
  final _errorMsgRead = "Couldn't read the User data!";
  final _errorMsgUpdate = "Couldn't update the User!";
  final _errorMsgDelete = "Couldn't delete the User!";
  final _errorMsgNotFound = 'User data not found!';
  final _errorMsgUserPhoto = "Couldn't upload the User photo!";

  //-- Public APIs
  Stream<User?> get _userStream => _auth.userChanges();
  AppUser get currentUser => _cache.value ?? AppUser.unauthenticated;

  /// Emit list of notification.
  Stream<(String?, AppUser)> get stream => _userStream.asyncMap(
        (user) async => user == null
            ? (null, AppUser.unauthenticated)
            : await read(user.uid),
      );

  // facto

  // static void get initialize => stream.first;

  /// Upload user photo to Storage and get URL.
  Future<({String? errorMsg, String? photoUrl})> uploadPhoto(
    String path, {
    required String userId,
  }) async {
    try {
      final storageRef = _storage.child('$userId.jpg');
      await storageRef.putFile(File(path));
      final photoUrl = await storageRef.getDownloadURL();
      return (errorMsg: null, photoUrl: photoUrl);
    } catch (e, s) {
      log(_errorMsgUserPhoto, error: e, stackTrace: s);
      return (errorMsg: _errorMsgUserPhoto, photoUrl: null);
    }
  }

  /// Get user's full name by id.
  Future<String?> nameById(String userId) async =>
      (await _db.child('$userId/name').get()).value as String?;

  /// Convert database snapshot to model with logic specified .
  Future<AppUser?> snapshotToModel(DataSnapshot snapshot) async {
    final userMap = snapshot.value?.toJson();

    if (userMap != null) {
      final designationIndex = userMap['designationIndex'] as int?;
      final departmentIndex = userMap['departmentIndex'] as int?;

      if (designationIndex != null && departmentIndex != null) {
        final designations = _cacheDesignations.value;
        final departments = _cacheDepartments.value;

        if (designations != null && departments != null) {
          final userJson = <String, Object?>{
            'id': snapshot.key,
            ...userMap,
            'designation': designations[designationIndex],
            'department': departments[departmentIndex],
          };
          return AppUser.fromJson(userJson);
        }
      }
    }
    return null;
  }

  /// Create user data to database.
  @override
  Future<String?> create(String userId, {required Json value}) async {
    try {
      // Upload user data to DB.
      await _db.child(userId).set(value);
    } catch (e, s) {
      log(_errorMsgCreate, error: e, stackTrace: s);
      return _errorMsgCreate;
    }
    return null;
  }

  @override
  Future<(String?, AppUser)> read(String userId) async {
    try {
      // Download user data from DB.
      final appUser = await _db.child(userId).get().then(snapshotToModel);
      if (appUser == null) return (_errorMsgNotFound, AppUser.unauthenticated);
      return (null, _cache.value = appUser);
    } catch (e, s) {
      log(_errorMsgRead, error: e, stackTrace: s);
      return (_errorMsgRead, AppUser.unauthenticated);
    }
  }

  /// Update user data to database.
  @override
  Future<String?> update(String userId, {required Json value}) async {
    try {
      await _db.child(userId).update(value);
    } catch (e, s) {
      log(_errorMsgUpdate, error: e, stackTrace: s);
      return _errorMsgUpdate;
    }
    return null;
  }

  /// Delete user data from database.
  @override
  Future<String?> delete(String userId) async {
    try {
      await _db.child(userId).remove();
    } catch (e, s) {
      log(_errorMsgDelete, error: e, stackTrace: s);
      return _errorMsgDelete;
    }
    return null;
  }
}
