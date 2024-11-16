import 'package:carpool_21_app/src/domain/models/role.dart';

class User {
  int? idUser;
  String name;
  String lastName;
  String? studentFile;
  int? dni;
  int phone;
  String address;
  String? email;
  String? password;
  String? passwordConfirm;
  String contactName;
  String contactLastName;
  int contactPhone;
  String? photoUser;
  String? notificationToken;
  List<Role>? roles;

  User({
    this.idUser,
    required this.name,
    required this.lastName,
    this.studentFile,
    this.dni,
    required this.phone,
    required this.address,
    this.email,
    this.password,
    this.passwordConfirm,
    required this.contactName,
    required this.contactLastName,
    required this.contactPhone,
    this.photoUser,
    this.notificationToken,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    idUser: json["idUser"],
    name: json["name"],
    lastName: json["lastName"],
    studentFile: json["studentFile"],
    dni: json["dni"] is String ? int.parse(json["dni"]) : json["dni"],
    phone: json["phone"] is String ? int.parse(json["phone"]) : json["phone"],
    address: json["address"],
    email: json["email"],
    contactName: json["contactName"],
    contactLastName: json["contactLastName"],
    contactPhone: json["contactPhone"] is String ? int.parse(json["contactPhone"]) : json["contactPhone"],
    // photoUser: json["photoUser"],
    // notificationToken: json["notification_token"],
    roles: json["roles"] != null ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    'idUser': idUser,
    'name': name,
    'lastName': lastName,
    'studentFile': studentFile,
    'dni': dni,
    'phone': phone,
    'address': address,
    'email': email,
    'password': password,
    'contactName': contactName,
    'contactLastName': contactLastName,
    'contactPhone': contactPhone,
    // 'photoUser': photoUser,
    // 'notification_token': notificationToken,
    'roles': roles != null ? List<dynamic>.from(roles!.map((x) => x.toJson())) : [],
  };
}