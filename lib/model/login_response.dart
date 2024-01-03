class LoginResponse {
  bool? status;
  String? message;
  Data? data;

  LoginResponse({this.status, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? email;
  bool? emailVerified;
  String? countryCode;
  String? phone;
  bool? phoneVerified;
  String? status;
  String? imgUrl;
  bool? gdpr;
  String? createdAt;
  String? updatedAt;
  String? authToken;
  RoleGroup? roleGroup;

  Data(
      {this.id,
        this.name,
        this.email,
        this.emailVerified,
        this.countryCode,
        this.phone,
        this.phoneVerified,
        this.status,
        this.imgUrl,
        this.gdpr,
        this.createdAt,
        this.updatedAt,
        this.authToken,
        this.roleGroup});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerified = json['email_verified'];
    countryCode = json['country_code'];
    phone = json['phone'];
    phoneVerified = json['phone_verified'];
    status = json['status'];
    imgUrl = json['img_url'];
    gdpr = json['gdpr'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    authToken = json['auth_token'];
    roleGroup = json['role_group'] != null
        ? RoleGroup.fromJson(json['role_group'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified'] = emailVerified;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['phone_verified'] = phoneVerified;
    data['status'] = status;
    data['img_url'] = imgUrl;
    data['gdpr'] = gdpr;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['auth_token'] = authToken;
    if (roleGroup != null) {
      data['role_group'] = roleGroup!.toJson();
    }
    return data;
  }
}

class RoleGroup {
  String? id;
  String? name;

  RoleGroup({this.id, this.name});

  RoleGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}