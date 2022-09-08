import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:tdd_clean_arch/presentation/protocols/protocols.dart';

import 'package:tdd_clean_arch/validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);
  
  @override
  String? validate({required String field, required String value}) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  test('Should return null if all validations returns null or empty', () {
    final validationNull = FieldValidationSpy();
    when(() => validationNull.field).thenReturn('any_field');
    when(() => validationNull.validate(any())).thenReturn(null);
    final validationEmpty = FieldValidationSpy();
    when(() => validationEmpty.field).thenReturn('any_field');
    when(() => validationEmpty.validate(any())).thenReturn('');
    final sut = ValidationComposite([validationNull, validationEmpty]);
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
}