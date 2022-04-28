enum dbOperations {
  get,
  create,
  update,
  getAll,
}

enum Register { hasAddedOTP }
enum CustomerTripType { CustomerToBusiness, BusinessToBusiness }
enum UserDetails {
  userName,
  userEmail,
  userId,
  userAccount,
  number,
  password,
  userPhoto
}
enum UserStation { stationID }
enum TripStatusEnums { COMPLETE, WAITING, ONTRIP }
enum TripType { b2b, b2c, tripType }
enum BusinessTripData { tripDescription, skillId }
enum Token { token, refreshToken }

String getEnumValue(var enumValue) {
  String data =
      enumValue.toString().substring(enumValue.toString().indexOf('.') + 1);
  return data;
}
