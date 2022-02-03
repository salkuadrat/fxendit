import 'address.dart';

/// Customer
class Customer {
  /// Customer ID
  final String id;

  /// Merchant ID
  final String referenceId;

  /// Email
  final String email;

  /// Given Names
  final String givenNames;

  /// Surname
  final String surname;

  /// Description
  final String description;

  /// Mobile Number
  final String mobileNumber;

  /// Phone Number
  final String phoneNumber;

  /// Nationality
  final String nationality;

  /// Date of Birth
  final String dateOfBirth;

  /// Card Info
  final Map<String, String> cardInfo;

  /// Address List
  final List<Address> addresses;

  const Customer({
    required this.id,
    required this.referenceId,
    required this.email,
    required this.givenNames,
    required this.surname,
    required this.description,
    required this.mobileNumber,
    required this.phoneNumber,
    required this.nationality,
    required this.dateOfBirth,
    this.cardInfo = const <String, String>{},
    this.addresses = const <Address>[],
  });

  /// Convert Map to Customer
  factory Customer.from(Map json) => Customer(
      id: json['id'],
      referenceId: json['referenceId'],
      email: json['email'],
      givenNames: json['givenNames'],
      surname: json['surname'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      phoneNumber: json['phoneNumber'],
      nationality: json['nationality'],
      dateOfBirth: json['dateOfBirth'],
      cardInfo: json['cardInfo'],
      addresses: (json['addresses'] as List)
          .map((item) => Address.from(item))
          .toList());

  /// Convert Customer to Map
  Map<String, dynamic> to() {
    return <String, dynamic>{
      'id': id,
      'referenceId': referenceId,
      'email': email,
      'givenNames': givenNames,
      'surname': surname,
      'description': description,
      'mobileNumber': mobileNumber,
      'phoneNumber': phoneNumber,
      'nationality': nationality,
      'dateOfBirth': dateOfBirth,
      'cardInfo': cardInfo,
      'addresses': addresses.map((address) => address.to()).toList(),
    };
  }
}
