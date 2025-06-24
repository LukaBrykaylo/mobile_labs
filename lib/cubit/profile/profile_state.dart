class ProfileState {
  final bool isLoading;
  final String? name;
  final String? email;
  final String? error;
  final bool loggedOut;

  ProfileState({
    required this.isLoading,
    this.name,
    this.email,
    this.error,
    this.loggedOut = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? name,
    String? email,
    String? error,
    bool? loggedOut,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      email: email ?? this.email,
      error: error ?? this.error,
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }
}
