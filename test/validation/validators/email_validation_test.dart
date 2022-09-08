import 'package:test/test.dart';

import 'package:tdd_clean_arch/validation/protocols/protocols.dart';

class EmailValidaton implements FieldValidation {
  @override
  final String field;

  EmailValidaton(this.field);

  @override
  String? validate(String? value) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value!);
    return isValid ? null : 'Campo inválido.';
  }
}

void main() {
  late EmailValidaton sut;

  setUp(() {
    sut = EmailValidaton('any_field');
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
