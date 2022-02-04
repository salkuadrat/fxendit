/// 3DS Recommendation
class ThreeDSRecommendation {
  /// Should 3DS
  final bool should3ds;

  /// Token ID
  final String tokenId;

  ThreeDSRecommendation({
    required this.should3ds,
    required this.tokenId,
  });

  /// Convert Map to ThreeDSRecommendation
  factory ThreeDSRecommendation.from(Map json) => ThreeDSRecommendation(
        should3ds: json['should3ds'] as bool,
        tokenId: json['tokenId'],
      );

  @override
  String toString() {
    return '<ThreeDSRecommendation: $tokenId, $should3ds>';
  }
}
