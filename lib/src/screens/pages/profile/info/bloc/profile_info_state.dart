import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:equatable/equatable.dart';

class ProfileInfoState extends Equatable {

  final User? user;

  const ProfileInfoState({
    this.user
  });

  ProfileInfoState copyWith({
    User? user
  }) {
    return ProfileInfoState(
      user: user ?? this.user
    );
  }

  @override
  List<Object?> get props => [user];
}