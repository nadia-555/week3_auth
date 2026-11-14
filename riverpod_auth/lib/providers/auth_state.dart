import '../models/user_model.dart';

/// حالة المصادقة: كائن غير قابل للتعديل (immutable).
/// أي تغيير ينشئ نسخة جديدة عبر copyWith.
class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.currentUser,
    this.resetIdentifier,
  });

  final bool isLoading;
  final String? errorMessage;
  final UserModel? currentUser;
  final String? resetIdentifier;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    UserModel? currentUser,
    String? resetIdentifier,
    bool clearResetIdentifier = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentUser: currentUser ?? this.currentUser,
      resetIdentifier: clearResetIdentifier
          ? null
          : (resetIdentifier ?? this.resetIdentifier),
    );
  }
}
