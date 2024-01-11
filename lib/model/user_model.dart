// ignore_for_file: public_member_api_docs, sort_constructors_first



class UserModel {
  String? name;
  String? email;
  String? phone;
  String? address;
  UserModel({
    this.name,
    this.email,
    this.phone,
    this.address
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
    );
  }


}
