// ignore_for_file: avoid_print
import 'dart:io';
import 'package:carpool_21_app/src/data/dataSource/remote/services/users_service.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/repository/users_repository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

class UsersRepositoryImpl extends UsersRepository {
  
  UsersService usersService;

  UsersRepositoryImpl(this.usersService);

  @override
  Future<Resource<User>> update(int id, User user, File? image) {
    if (image == null) {
      return usersService.update(id, user);
    } else {
      return usersService.updateImage(id, user, image);
    }
  }

  @override
  Future<Resource<User>> getUserDetail() {
    return usersService.getUserDetail();
  }
}