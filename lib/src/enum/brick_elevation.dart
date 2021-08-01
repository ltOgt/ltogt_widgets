enum BrickElevation {
  RECESSED,
  ELEVATED,
  FLAT,
}

extension BrickElevationExtension on BrickElevation {
  bool get isRecessed => this == BrickElevation.RECESSED;
  bool get isNotRecessed => !isRecessed;

  bool get isElevated => this == BrickElevation.ELEVATED;
  bool get isNotElevated => !isElevated;

  bool get isFlat => this == BrickElevation.FLAT;
  bool get isNotFlat => !isFlat;
}
