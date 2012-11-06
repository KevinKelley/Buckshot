part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/** Enumerates Input types. */
class InputTypes{
  final String _str;
  const InputTypes(this._str);

  static const password = const InputTypes("password");
  static const email = const InputTypes("email");
  static const date = const InputTypes("date");
  static const datetime = const InputTypes("datetime");
  static const month = const InputTypes("month");
  static const search = const InputTypes("search");
  static const telephone = const InputTypes("tel");
  static const text = const InputTypes("text");
  static const time = const InputTypes("time");
  static const url = const InputTypes("url");
  static const week = const InputTypes("week");

  static const List<InputTypes> validInputTypes =
      const <InputTypes>[
                         password,
                         email,
                         date,
                         datetime,
                         month,
                         search,
                         telephone,
                         text,
                         time,
                         url,
                         week];

  static bool _isValidInputType(InputTypes candidate){
    return validInputTypes.indexOf(candidate, 0) > -1;
  }

  String toString() => _str;
}


/** Provides a conversion between [String] and [InputTypes]. */
class StringToInputTypesConverter implements ValueConverter{
  const StringToInputTypesConverter();

  dynamic convert(dynamic value, {dynamic parameter}){
    if (value is! String) return value;

    switch(value){
    case "password":
      return InputTypes.password;
    case "email":
      return InputTypes.email;
    case "date":
      return InputTypes.date;
    case "datetime":
      return InputTypes.datetime;
    case "month":
      return InputTypes.month;
    case "search":
      return InputTypes.search;
    case "telephone":
      return InputTypes.telephone;
    case "text":
      return InputTypes.text;
    case "time":
      return InputTypes.time;
    case "url":
      return InputTypes.url;
    case "week":
      return InputTypes.week;
    default:
      throw const BuckshotException("Invalid InputTypes value.");
    }
  }
}
