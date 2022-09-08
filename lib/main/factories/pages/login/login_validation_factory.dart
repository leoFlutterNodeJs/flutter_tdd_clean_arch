import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() {
  return [
    const RequiredFieldValidation('email'),
    const EmailValidaton('email'),
    const RequiredFieldValidation('password')
  ];
}
