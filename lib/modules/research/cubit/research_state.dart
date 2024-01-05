part of 'research_cubit.dart';

enum ResearchStatus {
  initial,
  editing,
  loading,
  success,
  failure;

  bool get isLoading => this == ResearchStatus.loading;
}

class ResearchState extends Equatable {
  const ResearchState({
    this.status = ResearchStatus.initial,
    this.statusMsg,
    this.research,
    this.filePath = '',
  });

  final ResearchStatus status;
  final String? statusMsg;
  final Research? research;
  final String filePath;

  ResearchState copyWith({
    ResearchStatus? status,
    String? statusMsg,
    Research? research,
    String? filePath,
  }) {
    return ResearchState(
      status: status ?? this.status,
      statusMsg: statusMsg ?? this.statusMsg,
      research: research ?? this.research,
      filePath: filePath ?? this.filePath,
    );
  }

  @override
  List<Object?> get props => [status, statusMsg, research, filePath];
}
