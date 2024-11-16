
class Role {
  String? idRole;
  String? name;
  bool? status;
  bool? isActive;
  String? route;

  Role({
    this.idRole, 
    this.name, 
    this.status,
    this.isActive,
    this.route
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    idRole: json["idRole"],
    name: json["name"],
    status: json["status"],
    isActive: json["isActive"],
    route: json["route"],
  );

  Map<String, dynamic> toJson() => {
    'idRole': idRole,
    'name': name,
    'status': status,
    'isActive': isActive,
    'route': route,
  };
}