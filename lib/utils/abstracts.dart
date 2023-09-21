import 'package:su_thesis_book/utils/utils.dart';

abstract class CrudAbstract<T> {
  Future<String?> create(String id, {required Json value});

  Future<(String?, {T? object})> read(String id);

  Future<String?> update(String id, {required Json value});

  Future<String?> delete(String id);
}