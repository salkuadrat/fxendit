/// Address
class Address {
  /// Country
  final String country;

  /// Street line 1
  final String streetLine1;

  /// Street line 2
  final String streetLine2;

  /// City
  final String city;

  /// Province / State
  final String provinceState;

  /// Post Code
  final String postalCode;

  /// Category
  final String category;

  const Address({
    required this.country,
    required this.streetLine1,
    required this.streetLine2,
    required this.city,
    required this.provinceState,
    required this.postalCode,
    required this.category,
  });

  /// Convert Map to Address
  factory Address.from(Map json) => Address(
        country: json['country'],
        streetLine1: json['streetLine1'],
        streetLine2: json['streetLine2'],
        city: json['city'],
        provinceState: json['provinceState'],
        postalCode: json['postalCode'],
        category: json['category'],
      );

  /// Convert Address to Map
  Map<String, dynamic> to() {
    return <String, dynamic>{
      'country': country,
      'streetLine1': streetLine1,
      'streetLine2': streetLine2,
      'city': city,
      'provinceState': provinceState,
      'postalCode': postalCode,
      'category': category,
    };
  }
}
