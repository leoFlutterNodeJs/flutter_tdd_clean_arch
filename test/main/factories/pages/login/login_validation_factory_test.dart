import 'package:tdd_clean_arch/main/factories/pages/pages.dart';
import 'package:tdd_clean_arch/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validation', () {
    final validations = makeLoginValidations();

    expect(validations, [
      const RequiredFieldValidation('email'),
      const EmailValidaton('email'),
      const RequiredFieldValidation('password')
    ]);
  });
}
