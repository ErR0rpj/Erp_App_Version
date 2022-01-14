part of 'consts.dart';

String? emailValidator(String? value) {
  RegExp regex = new RegExp(EMAIL_PATTERN);
  if (value!= null && !regex.hasMatch(value)) {
    return '';
  } else {
    return null;
  }
}

String? pwdValidator(String? value) {
  if (value!=null && value.length < MINIMUM_PASSWORD_LENGTH) {
    return '';
  } else {
    return null;
  }
}

String? nameValidator(String? value) {
  if (value!=null && value.length < MINIMUM_NAME_LENGTH) {
    return '';
  } else {
    return null;
  }
}
