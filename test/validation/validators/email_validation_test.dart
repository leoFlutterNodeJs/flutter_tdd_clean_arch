import 'package:test/test.dart';

import 'package:tdd_clean_arch/validation/validators/validators.dart';

void main() {
  late EmailValidaton sut;

  setUp(() {
    sut = const EmailValidaton('any_field');
  });

  test('Should returns null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should returns null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should returns null if email is valid', () {
    expect(sut.validate('test@gmail.com'), null);
  });

  test('Should returns error if email is invalid', () {
    expect(sut.validate('test'), 'Campo inválido.');
  });
}
