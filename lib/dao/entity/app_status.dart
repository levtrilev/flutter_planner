class AppStatus {
  final bool isAuthInProgress;
  final bool isTodoLoadInProgress;
  final String userToken;
  final int userId;
  final bool appStateIsInitializing;

  AppStatus({
    required this.isAuthInProgress,
    required this.isTodoLoadInProgress,
    required this.userToken,
    required this.userId,
    required this.appStateIsInitializing,
  });

  AppStatus copy({
    bool? isAuthInProgress,
    bool? isTodoLoadInProgress,
    String? userToken,
    int? userId,
    bool? appStateIsInitializing,
  }) {
    return AppStatus(
      isAuthInProgress: isAuthInProgress ?? this.isAuthInProgress,
      isTodoLoadInProgress: isTodoLoadInProgress ?? this.isTodoLoadInProgress,
      userToken: userToken ?? this.userToken,
      userId: userId ?? this.userId,
      appStateIsInitializing:
          appStateIsInitializing ?? this.appStateIsInitializing,
    );
  }

  static AppStatus initialState(String token, int userId) {
    return AppStatus(
      isAuthInProgress: false,
      isTodoLoadInProgress: false,
      userToken: token,
      userId: userId,
      appStateIsInitializing: true,
    );
  }
}
