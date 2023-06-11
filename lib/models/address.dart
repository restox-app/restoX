class AddressInline {
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String pinCode;

  AddressInline({
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.pinCode,
  });

  factory AddressInline.fromJSON(Map<String, dynamic> json) {
    return AddressInline(
      line1: json['line1'],
      line2: json['line2'],
      city: json['city'],
      state: json['state'],
      pinCode: json['pin_code'],
    );
  }
}