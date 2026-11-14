import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_notifier.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _otpCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref.read(authProvider.notifier).resetPassword(
      code: _otpCtrl.text.trim(),
      newPassword: _passCtrl.text,
    );
    if (!mounted) return;
    if (!ok) {
      showAppSnack(
          context, ref.read(authProvider).errorMessage ?? 'فشل تحديث كلمة المرور');
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('تم التحديث'),
        content: const Text('تم تحديث كلمة المرور بنجاح، يمكنك تسجيل الدخول الآن.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('الذهاب لتسجيل الدخول'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعيين كلمة مرور جديدة')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _otpCtrl,
                      validator: FormValidators.otp,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.center,
                      style: const TextStyle(letterSpacing: 8, fontSize: 20),
                      decoration: const InputDecoration(
                        labelText: 'رمز التحقق (6 أرقام)',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 14),
                    PasswordField(
                      controller: _passCtrl,
                      label: 'كلمة المرور الجديدة',
                      validator: FormValidators.strongPassword,
                    ),
                    const SizedBox(height: 14),
                    PasswordField(
                      controller: _confirmCtrl,
                      label: 'تأكيد كلمة المرور الجديدة',
                      validator: (v) =>
                          FormValidators.confirmPassword(v, _passCtrl.text),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                    LoadingButton(
                      label: 'تحديث كلمة المرور',
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
