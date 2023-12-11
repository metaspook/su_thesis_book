import 'package:equatable/equatable.dart';
import 'package:su_thesis_book/utils/utils.dart';

class Research extends Equatable {
  const Research({
    required this.id,
    required this.publisher,
    this.createdAt,
    this.title,
    this.views,
    this.fileUrl,
    this.category,
  });

  factory Research.fromJson(Map<String, dynamic> json) {
    return Research(
      id: json['id'] as String,
      publisher: json['publisher'] as Publisher?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      title: json['title'] as String?,
      views: json['views'] as int?,
      fileUrl: json['fileUrl'] as String?,
      category: json['category'] as String?,
    );
  }

  final String id;
  final Publisher? publisher;
  final DateTime? createdAt;
  final String? title;
  final int? views;
  final String? fileUrl;
  final String? category;

  Json toJson() {
    return <String, dynamic>{
      'id': id,
      'publisher': publisher?.toJson(),
      'createdAt': createdAt.toString(),
      'title': title,
      'views': views,
      'fileUrl': fileUrl,
      'category': category,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      publisher,
      createdAt,
      title,
      views,
      fileUrl,
      category,
    ];
  }

  @override
  bool get stringify => true;
}

// extension PublishersExt on List<Research> {
//   List<Publisher> get publishers => <Publisher>[
//         for (final e in this)
//           if (e.publisher != null) e.publisher!,
//       ];
// }
