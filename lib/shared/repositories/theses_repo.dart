import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cache/cache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:su_thesis_book/shared/models/models.dart';
import 'package:su_thesis_book/utils/utils.dart';

typedef ThesesRecord = (String?, List<Thesis>?);

class ThesesRepo implements CRUD<Thesis> {
  //-- Config
  final _cacheDesignations = const Cache<List<String>>('designations');
  final _cacheDepartments = const Cache<List<String>>('departments');
  final _dbBookmarks = FirebaseDatabase.instance.ref('bookmarks/thesis');
  final _cache = const Cache<List<Thesis>>('theses');
  final _db = FirebaseDatabase.instance.ref('theses');
  final _dbUsers = FirebaseDatabase.instance.ref('users');
  final _storage = FirebaseStorage.instance.ref('theses');
  final _filePicker = FilePicker.platform;
  final _errorMsgThesesNotFound = 'Theses not found!';
  final _errorMsgTheses = "Couldn't get the theses!";
  final _errorMsgCreate = "Couldn't create the Thesis!";
  final _errorMsgRead = "Couldn't read the Thesis data!";
  final _errorMsgUpdate = "Couldn't update the Thesis!";
  final _errorMsgDelete = "Couldn't delete the Thesis!";
  // final _errorMsgNotFound = 'Thesis data not found!';
  final _errorMsgUploadFile = "Couldn't upload the thesis file!";
  final _errorMsgFilePicker = "Couldn't pick the file!";
  final _errorMsgTempFiles = "Couldn't clear the temporary file!";

  // pick files.
  Future<({String? errorMsg, FilePickerResult? result})> _pickFile() async {
    final result = await _filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    return result == null
        ? (errorMsg: _errorMsgFilePicker, result: null)
        : (errorMsg: null, result: result);
  }

  //-- Public APIs
  /// Generates a new thesis id.
  String get newId => _db.push().key ?? uuid;

  /// Get publisher by userId.
  Future<Publisher?> publisherById(String id) async {
    final snapshot = await _dbUsers.child(id).get();
    final publisherMap = snapshot.value?.toJson();
    final designationIndex = publisherMap?['designationIndex'] as int?;
    final departmentIndex = publisherMap?['departmentIndex'] as int?;

    if (designationIndex != null && departmentIndex != null) {
      final designations = _cacheDesignations.value;
      final departments = _cacheDepartments.value;
      return Publisher(
        id: snapshot.key!,
        name: publisherMap?['name'] as String?,
        designation: designations?[designationIndex],
        department: departments?[departmentIndex],
        photoUrl: publisherMap?['photoUrl'] as String?,
      );
    }
    return null;
  }

  /// Get thesis by Id.
  Future<Thesis?> thesisById(String id) async {
    final theses = await stream.first;
    for (final thesis in theses) {
      if (thesis.id == id) return thesis;
    }
    return null;
  }

  /// Convert database snapshot to model with logic specified.
  Future<Thesis?> snapshotToModel(DataSnapshot snapshot) async {
    final thesisMap = snapshot.value?.toJson();
    final userId = thesisMap?['userId'] as String?;
    final departmentIndex = thesisMap?['departmentIndex'] as int?;

    if (userId != null && departmentIndex != null) {
      final publisher = await publisherById(userId);
      final departments = _cacheDepartments.value;
      final thesisJson = <String, Object?>{
        'id': snapshot.key,
        'publisher': publisher?.toJson(),
        ...?thesisMap,
        'department': departments?[departmentIndex],
      };
      return Thesis.fromJson(thesisJson);
    }
    return null;
  }

  /// Emits list of thesis.
  Stream<List<Thesis>> get stream async* {
    if (_cache.value != null) yield _cache.value!;
    yield* _db.onValue.asyncMap<List<Thesis>>(
      (event) async {
        final theses = <Thesis>[];
        for (final snapshot in event.snapshot.children) {
          final thesis = await snapshotToModel(snapshot);
          if (thesis != null) theses.add(thesis);
        }
        return _cache.value = theses;
      },
    );
  }

  /// Upload thesis file to Storage and get URL.
  Future<({String? errorMsg, String? fileUrl})> uploadFile(String path) async {
    try {
      final file = File(path);
      final fileName = file.uri.pathSegments.last;
      final storageRef = _storage.child(fileName);
      await storageRef.putFile(file);
      final fileUrl = await storageRef.getDownloadURL();
      return (errorMsg: null, fileUrl: fileUrl);
    } catch (e, s) {
      log(_errorMsgUploadFile, error: e, stackTrace: s);
      return (errorMsg: _errorMsgUploadFile, fileUrl: null);
    }
  }

  /// Clear temporary picked files.
  Future<String?> clearTemp() async =>
      (await _filePicker.clearTemporaryFiles() ?? false)
          ? null
          : _errorMsgTempFiles;

  Future<({String? errorMsg, String? path})> pickToPath() async {
    final pickFileRecord = await _pickFile();
    return (
      errorMsg: pickFileRecord.errorMsg,
      path: pickFileRecord.result?.files.first.path
    );
  }

  // useful for web and Image.memory widget.
  Future<({String? errorMsg, Uint8List? bytes})> pickToBytes() async {
    final pickFileRecord = await _pickFile();
    return (
      errorMsg: pickFileRecord.errorMsg,
      bytes: pickFileRecord.result?.files.first.bytes
    );
  }

  @override
  Future<String?> create(String id, {required Json value}) async {
    try {
      await _db.child(id).set(value);
    } catch (e, s) {
      log(_errorMsgCreate, error: e, stackTrace: s);
      return _errorMsgCreate;
    }
    return null;
  }

  @override
  Future<(String?, Thesis)> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<String?> update(String id, {required Json value}) async {
    try {
      await _db.child(id).update(value);
    } catch (e, s) {
      log(_errorMsgUpdate, error: e, stackTrace: s);
      return _errorMsgUpdate;
    }
    return null;
  }

  @override
  Future<String?> delete(String id) async {
    try {
      // Remove from cache and database.
      final thesis = await thesisById(id);
      _cache.value?.remove(thesis);
      await _db.child(id).remove();
    } catch (e, s) {
      log(_errorMsgDelete, error: e, stackTrace: s);
      return _errorMsgDelete;
    }
    return null;
  }
}