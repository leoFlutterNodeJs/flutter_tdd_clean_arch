import 'package:test/test.dart';

import 'package:tdd_clean_arch/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp((){
    sut = const RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório.');
  });

   test('Should return error if value is null', () {
    expect(sut.validate(null), 'Campo obrigatório.');
  });
}