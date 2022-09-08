import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() => ValidationComposite([
      RequiredFieldValidation('email'),
      EmailValidaton('email'),
      RequiredFieldValidation('password')
    ]);
