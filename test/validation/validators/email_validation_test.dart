import 'package:test/test.dart';

import 'package:tdd_clean_arch/validation/protocols/protocols.dart';

class EmailValidaton implements FieldValidation {
  @override
  final String field;

  EmailValidaton(this.field);

  @override
  String? validate(String? value) {
    return null;
  }
}

void main() {
  
  test('Should returns null if email is empty', () {
    final sut = EmailValidaton('any_field');
    final error = sut.validate('');

    expect(error, null);
  });

    test('Should returns null if email is null', () {
    final sut = EmailValidaton('any_field');
    final error = sut.validate(null);

    expect(error, null);
  });
  
}