import 'address.dart';

/// Billing Details
class BillingDetails {
  /// Given Names
  final String givenNames;

  /// Surname
  final String surname;

  /// Email
  final String email;

  /// Mobile Number
  final String mobileNumber;

  /// Phone Number
  final String phoneNumber;

  /// Address
  final Address address;

  const BillingDetails({
    required this.givenNames,
    required this.surname,
    required this.email,
    required this.mobileNumber,
    required this.phoneNumber,
    required this.address,
  });

  /// Convert Map to BillingDetails
  factory BillingDetails.from(Map json) => BillingDetails(
        givenNames: json['givenNames'],
        surname: json['surname'],
        email: json['email'],
        mobileNumber: json['mobileNumber'],
        phoneNumber: json['phoneNumber'],
        address: Address.from(
          json['address'],
        ),
      );

  /// Convert BillingDetails to Map
  Map<String, dynamic> to() {
    return <String, dynamic>{
      'givenNames': givenNames,
      'surname': surname,
      'email': email,
      'mobileNumber': mobileNumber,
      'phoneNumber': phoneNumber,
      'address': address.to(),
    };
  }
}
