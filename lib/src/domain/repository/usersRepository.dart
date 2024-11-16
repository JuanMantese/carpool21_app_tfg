
import 'dart:io';

import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class UsersRepository {

  // User --> Information that the server returns to us
  Future<Resource<User>> update(int id, User user, File? image);

  // User --> Information that the server returns to us
  Future<Resource<User>> getUserDetail();

}