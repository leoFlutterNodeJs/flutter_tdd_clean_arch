import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite extends Equatable implements Validation {
  final List<FieldValidation> validations;

  @override
  List get props => [validations];

  const ValidationComposite(this.validations);
  
  @override
  String? validate({required String field, required String value}) {
    String? error;
    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if(error != null && error.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}