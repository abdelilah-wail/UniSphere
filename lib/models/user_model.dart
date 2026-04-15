class UserModel {
  final String id;
  final String name;
  final String email;
  final String? studentId;
  final String role;
  final String? avatar;
  final double gpa;
  final int creditsEarned;
  final int totalCredits;
  final int yearLevel;
  final UserPreferences preferences;
  final UserPrivacy privacy;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.studentId,
    this.role = 'student',
    this.avatar,
    this.gpa = 0,
    this.creditsEarned = 0,
    this.totalCredits = 130,
    this.yearLevel = 1,
    required this.preferences,
    required this.privacy,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      studentId: json['studentId'],
      role: json['role'] ?? 'student',
      avatar: json['avatar'],
      gpa: (json['gpa'] ?? 0).toDouble(),
      creditsEarned: json['creditsEarned'] ?? 0,
      totalCredits: json['totalCredits'] ?? 130,
      yearLevel: json['yearLevel'] ?? 1,
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      privacy: UserPrivacy.fromJson(json['privacy'] ?? {}),
    );
  }
}

class UserPreferences {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool darkMode;

  UserPreferences({
    this.pushNotifications = true,
    this.emailNotifications = false,
    this.darkMode = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      pushNotifications: json['pushNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? false,
      darkMode: json['darkMode'] ?? false,
    );
  }
}

class UserPrivacy {
  final bool profileVisible;
  final bool showEmail;
  final bool activityStatus;
  final bool dataSharing;

  UserPrivacy({
    this.profileVisible = true,
    this.showEmail = false,
    this.activityStatus = true,
    this.dataSharing = true,
  });

  factory UserPrivacy.fromJson(Map<String, dynamic> json) {
    return UserPrivacy(
      profileVisible: json['profileVisible'] ?? true,
      showEmail: json['showEmail'] ?? false,
      activityStatus: json['activityStatus'] ?? true,
      dataSharing: json['dataSharing'] ?? true,
    );
  }
}
