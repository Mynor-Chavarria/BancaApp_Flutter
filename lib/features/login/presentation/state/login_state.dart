class LoginState {
  final String title;
  final bool logged;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMessage;

  LoginState({
    required this.title,
    required this.logged,
    required this.obscurePassword,
    required this.isLoading,
    this.errorMessage,
  });

  LoginState copyWith({
    String? title,
    bool? logged,
    bool? obscurePassword,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      title: title ?? this.title,
      logged: logged ?? this.logged,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
