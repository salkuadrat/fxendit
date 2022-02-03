/// Card Info
class CardInfo {
  /// Bank
  final String bank;

  /// Country
  final String country;

  /// Card Type
  final String type;

  /// Brand
  final String? brand;

  /// Card Art URL
  final String? cardArtUrl;

  /// Card Fingerprint
  final String? fingerprint;

  const CardInfo({
    required this.bank,
    required this.country,
    required this.type,
    this.brand,
    this.cardArtUrl,
    this.fingerprint,
  });

  /// Convert Map to CardInfo
  factory CardInfo.from(Map json) => CardInfo(
        bank: json['bank'],
        country: json['country'],
        type: json['type'],
        brand: json['brand'],
        cardArtUrl: json['cardArtUrl'],
        fingerprint: json['fingerprint'],
      );
}
