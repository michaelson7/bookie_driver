enum dbOperations {
  get,
  create,
  update,
  getAll,
}

enum UserDetails { userName, userEmail, userId, userAccount }
enum UserStation { stationID }
enum TripStatusEnums { COMPLETE, WAITING, ONTRIP }
enum TripType { b2b, b2c, tripType }
enum Token { token, refreshToken }

String getEnumValue(var enumValue) {
  String data =
      enumValue.toString().substring(enumValue.toString().indexOf('.') + 1);
  return data;
}
