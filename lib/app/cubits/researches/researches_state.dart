part of 'researches_cubit.dart';

enum ResearchesStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == ResearchesStatus.loading;
}

class ResearchesState extends Equatable {
  const ResearchesState({
    this.status = ResearchesStatus.initial,
    this.statusMsg,
    this.researches,
  });

  factory ResearchesState.fromJson(Map<String, dynamic> json) {
    return ResearchesState(
      researches: [for (final e in json['researches'] as List) e as Research],
    );
  }

  final ResearchesStatus status;
  final String? statusMsg;
  final List<Research>? researches;
  bool get hasMessage => statusMsg != null;
  List<Publisher>? get publishers => researches == null
      ? null
      : <Publisher>[
          for (final e in researches!)
            if (e.publisher != null) e.publisher!,
        ].unique;

  Json toJson() {
    return <String, dynamic>{
      'researches': researches?.map((e) => e.toJson()).toList(),
    };
  }

  ResearchesState copyWith({
    ResearchesStatus? status,
    String? statusMsg,
    List<Research>? researches,
  }) {
    return ResearchesState(
      status: status ?? this.status,
      statusMsg: statusMsg ?? this.statusMsg,
      researches: researches ?? this.researches,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      statusMsg,
      researches,
    ];
  }
}