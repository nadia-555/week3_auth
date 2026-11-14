import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_requests.dart';
import '../repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';
import 'auth_state.dart';

/// Provider للـ Repository: هنا يتم الحقن. للاختبار يمكن استبداله بـ override.
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepositoryImpl());

/// Provider للـ Notifier: الواجهة تراقب `authProvider` وتستدعي `authProvider.notifier`.
final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// الـ Controller بنسخة Riverpod 2.x (Notifier).
class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() => const AuthState();

  /// تنفّذ أي عملية مع إدارة التحميل والأخطاء، وترجع true عند النجاح.
  Future<bool> _run(Future<void> Function() action) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await action();
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(errorMessage: 'حدث خطأ غير متوقع، حاول مرة أخرى');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> login(LoginRequest request) => _run(() async {
        final user = await _repository.login(request);
        state = state.copyWith(currentUser: user);
      });

  Future<bool> register(RegisterRequest request) => _run(() async {
        await _repository.register(request);
      });

  Future<bool> sendPasswordResetCode(String identifier) => _run(() async {
        await _repository.sendPasswordResetCode(identifier);
        state = state.copyWith(resetIdentifier: identifier.trim());
      });

  Future<bool> resetPassword({
    required String code,
    required String newPassword,
  }) =>
      _run(() async {
        await _repository.resetPassword(ResetPasswordRequest(
          identifier: state.resetIdentifier ?? '',
          code: code,
          newPassword: newPassword,
        ));
        state = state.copyWith(clearResetIdentifier: true);
      });
}
