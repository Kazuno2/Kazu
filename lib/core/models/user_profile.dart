class UserProfile {
  String displayName;
  String buddyName;
  List<String> focusPillarIds;
  double? heightCm;
  double? weightKg;
  String? bodyFatSelfEstimate;
  bool isOnboardingComplete;

  UserProfile({
    this.displayName = 'Friend',
    this.buddyName = 'Buddy',
    List<String>? focusPillarIds,
    this.heightCm,
    this.weightKg,
    this.bodyFatSelfEstimate,
    this.isOnboardingComplete = false,
  }) : focusPillarIds = focusPillarIds ?? [];

  double? get calculatedBmi {
    if (heightCm != null && weightKg != null && heightCm! > 50 && weightKg! > 20) {
      final hMeters = heightCm! / 100.0;
      return weightKg! / (hMeters * hMeters);
    }
    return null;
  }
}

