import 'package:flutter_test/flutter_test.dart';
import 'package:getx_auth/utils/form_validators.dart';

void main() {
  group('FormValidators', () {
    test('identifier', () {
      expect(FormValidators.identifier(''), isNotNull);
      expect(FormValidators.identifier('1234'), isNotNull);
      expect(FormValidators.identifier('a@b'), isNotNull);
      expect(FormValidators.identifier('student@univ.edu'), isNull);
      expect(FormValidators.identifier('202312345'), isNull);
    });

    test('academicId', () {
      expect(FormValidators.academicId('12345678'), isNotNull);
      expect(FormValidators.academicId('12345678a'), isNotNull);
      expect(FormValidators.academicId('123456789'), isNull);
      expect(FormValidators.academicId('1234567890'), isNull);
    });

    test('strongPassword', () {
      expect(FormValidators.strongPassword('Ab1'), isNotNull);
      expect(FormValidators.strongPassword('abcdefg1'), isNotNull);
      expect(FormValidators.strongPassword('Abcdefgh'), isNotNull);
      expect(FormValidators.strongPassword('Abcdefg1'), isNull);
    });

    test('confirmPassword and otp', () {
      expect(FormValidators.confirmPassword('a', 'b'), isNotNull);
      expect(FormValidators.confirmPassword('a', 'a'), isNull);
      expect(FormValidators.otp('12345'), isNotNull);
      expect(FormValidators.otp('123456'), isNull);
    });
  });
}
