class ApiErrorV1 {
  final String code;
  final String msg;
  final String error;

  ApiErrorV1({
    required this.code,
    required this.msg,
    required this.error,
  });

  factory ApiErrorV1.fromJSON(Map<String, dynamic> json) {
    return ApiErrorV1(
      code: json['code'],
      msg: json['msg'],
      error: json['error'],
    );
  }
}
