
class Validator {

  static String? nameValidate(String value) {
    if (value.isEmpty) {
      return "Name cannot be Empty";
    } else if (!value.contains(RegExp(r'[A-z]'))) {
      return "Invalid Name.";
    } else if (value.length < 3) {
      return "Invalid Name.";
    }
    return null;
  }


  static String? passwordValidate(String passwordValue) {
    if (passwordValue.isEmpty) {
      return "Password Cannot be Empty";
    } else if (!passwordValue.contains(RegExp(r'[a-zA-Z0-9]'))) {
      return "Invalid Password";
    }else if(passwordValue.length < 6){
      return "Enter valid Password.(Min. 6 characters)";
    }
    return null;
  }

  static String? confirmPasswordValidate(String passwordValue,String confirmValue){
    if(passwordValue != confirmValue){
      return 'Password do not match';
    }
    return null;
  }

  static String? emailValidate(String emailValue){
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(pattern);
    if (emailValue.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!regExp.hasMatch(emailValue)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  static String? videoValidate(String value) {
    if (value.isEmpty) {
      return "Name cannot be Empty";
    } else if (value.length < 3) {
      return "Invalid Name.";
    }
    return null;
  }
}
