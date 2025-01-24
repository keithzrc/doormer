// TODO: use JsonSerializable once finalized
class VerificationTokenModel {
  final String token;

  VerificationTokenModel(this.token);

  factory VerificationTokenModel.fromJson(Map<String, dynamic> json) {
    return VerificationTokenModel(json['token']);
  }

  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}
