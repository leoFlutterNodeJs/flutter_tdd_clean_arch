import '../../validation/protocols/protocols.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static late ValidationBuilder _instance;
  late String fieldName;
  List<FieldValidation> validations = [];

  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

   ValidationBuilder email() {
    validations.add(EmailValidaton(fieldName));
    return this;
  }

  List<FieldValidation> build() => validations;
}
