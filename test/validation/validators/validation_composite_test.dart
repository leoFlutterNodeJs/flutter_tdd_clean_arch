import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:tdd_clean_arch/validation/protocols/protocols.dart';
import 'package:tdd_clean_arch/validation/validators/validators.dart';


class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidationSpy validationNull;
  late FieldValidationSpy validationEmpty;
  late FieldValidationSpy validationOtherFields;

  void mockValidationNull(String? error) {
    when(() => validationNull.validate(any())).thenReturn(error);
  }

  void mockValidationEmpty(String? error) {
    when(() => validationEmpty.validate(any())).thenReturn(error);
  }
  
  void mockValidationOtherFields(String? error) {
    when(() => validationOtherFields.validate(any())).thenReturn(error);
  }

  setUp((){
    validationNull = FieldValidationSpy();
    when(() => validationNull.field).thenReturn('other_field');
    mockValidationNull(null);
    validationEmpty = FieldValidationSpy();
    when(() => validationEmpty.field).thenReturn('any_field');
    validationOtherFields = FieldValidationSpy();
    when(() => validationOtherFields.field).thenReturn('any_field');
    mockValidationOtherFields(null);
    sut = ValidationComposite([validationNull, validationEmpty, validationOtherFields]);
  });

  test('Should return null if all validations returns null or empty', () {
    mockValidationEmpty('');
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });

  test('Should return first error', () {
    mockValidationNull('error_null');
    mockValidationEmpty('error_empty');
    mockValidationOtherFields('error_other_fields');
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, 'error_empty');
  });

}