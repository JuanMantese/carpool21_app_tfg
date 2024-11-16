part of 'error_bloc.dart';

abstract class ErrorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialErrorState extends ErrorState {}

class ErrorMessageState extends ErrorState {
  final String message;
  final String? subtitle;
  final AssetImage? errorImage;

  ErrorMessageState({required this.message, this.subtitle, this.errorImage});

  @override
  List<Object?> get props => [message, subtitle, errorImage];

  ErrorMessageState copyWith({
    String? message,
    String? subtitle,
    AssetImage? errorImage,
  }) {
    return ErrorMessageState(
      message: message ?? this.message,
      subtitle: subtitle ?? this.subtitle,
      errorImage: errorImage ?? this.errorImage,
    );
  }
}