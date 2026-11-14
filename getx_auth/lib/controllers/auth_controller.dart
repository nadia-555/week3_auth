import 'package:get/get.dart';

import '../models/auth_requests.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

/// الـ Controller بنسخة GetX: الحالة متغيرات reactive (.obs)
/// والواجهة تقرأها داخل Obx فتُعاد بناء الجزء المتأثر فقط.
class AuthController extends GetxController {
  AuthController(this._repository);

  final AuthRepository _repository;

  // ---------------- الحالة (Rx) ----------------
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final currentUser = Rxn<UserModel>();
  final resetIdentifier = RxnString();

  /// تنفّذ أي عملية مع إدارة التحميل والأخطاء، وترجع true عند النجاح.
  Future<bool> _run(Future<void> Function() action) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await action();
      return true;
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'حدث خطأ غير متوقع، حاول مرة أخرى';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(LoginRequest request) => _run(() async {
        currentUser.value = await _repository.login(request);
      });

  Future<bool> register(RegisterRequest request) => _run(() async {
        await _repository.register(request);
      });

  Future<bool> sendPasswordResetCode(String identifier) => _run(() async {
        await _repository.sendPasswordResetCode(identifier);
        resetIdentifier.value = identifier.trim();
      });

  Future<bool> resetPassword({
    required String code,
    required String newPassword,
  }) =>
      _run(() async {
        await _repository.resetPassword(ResetPasswordRequest(
          identifier: resetIdentifier.value ?? '',
          code: code,
          newPassword: newPassword,
        ));
        resetIdentifier.value = null;
      });
}
