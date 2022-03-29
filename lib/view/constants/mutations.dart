String createAccount = """
mutation CreateAccount(
  \$email: String!, 
  \$phoneNumber:String!, 
  \$firstName: String!,
  \$lastName: String!,
  \$password: String!, 
){
  createAccount(
    data: {
      email: \$email,
      phoneNumber: \$phoneNumber,
      firstName: \$firstName,
      lastName: \$lastName,
      password: \$password,
    }
  ){
    response,
    message
  }
}
""";

String tokenAuth = """
mutation tokenAuth(
\$password: String!,
\$phoneNumber: String!,
){
tokenAuth(
password: \$password,
phoneNumber: \$phoneNumber
){
success,
token,
refreshToken
}
}
""";

String verifyPhoneNumber = """
mutation verifyPhoneNumber(
  \$otp: String!,
	\$phoneNumber:String!,
){
  verifyPhoneNumber(
  data:{
    otp: \$otp,
    phoneNumber: \$phoneNumber,
  }){
  response,
  message
  }
}
""";

String createDriver = """
mutation createDriver(
  \$user: ID!,
  \$nrcNumber:String!,
  \$skills:[ID]!,
  ){
   createDriver(data: {
    user:\$user,
    nrcNumber:\$nrcNumber,
    skills: \$skills
  }) {
    response,
    message
  }
}
""";

String refreshToken = """
 mutation refreshToken(
    \$refreshToken: String!, 
){
  refreshToken(
    refreshToken: \$refreshToken
  ),{
    success,
    refreshToken,
    token
  }
}
""";

String verifyToken = """
mutation verifyToken(
\$token: String!,
){
verifyToken(
token: \$token,
),{
success,
}
}
""";

String me = """
query{
  me{
    pk,
    firstName,
    lastName,
    email,
    driverSet{
      active,
      id
    }
  }
}
""";

String addDriverVehicle = """
mutation addDriverVehicle(
  \$vehicleClass: ID!, 
  \$driver: ID!, 
  \$modelName: String!, 
  \$modelColor: String!, 
  \$insuranceDate: String!, 
  \$roadTaxDate: String!, 
  \$registrationPlate: String!, 
){
  addDriverVehicle(data: {
    vehicleClass: \$vehicleClass
    driver:  \$driver,
    modelName: \$modelName,
    modelColor: \$modelColor,
    insuranceDate: \$insuranceDate,
    roadTaxDate: \$roadTaxDate,
    registrationPlate: \$registrationPlate,
  }){
    response
    message
  }
}
""";

String addDriverLocation = """
mutation addDriverLocation(
  \$driver: ID!, 
  \$latitude: String!, 
  \$longitude: String!, 
){
  addDriverLocation(data: {
    driver: \$driver
    latitude:  \$latitude,
    longitude: \$longitude
  }){
    response
    message
  }
}
""";

String addRequestTrip = """
mutation  addRequestTrip(
  \$user: ID!, 
  \$status: String!, 
  \$startLatitude: String!, 
  \$startLongitude: String!, 
  \$endLatitude: String!, 
 \$endLongitude: String!, 
){
  addRequestTrip(
   data:{
     user:\$user,
     status:\$status
  },
    pickupLocation:{
      latitude:\$startLatitude,
      longitude:\$startLongitude
    },
     endLocation:{
      latitude:\$endLatitude,
      longitude:\$endLongitude
    }
  ){
    response,
    message
  }
}
""";

String depositMoney = """
mutation  depositMoney(
  \$driver: ID!, 
  \$amount: String!,   
){
  depositMoney(
   data:{
     driver: \$driver,
     amount:\$amount
  } 
  ){
    response,
    message
  }
}
""";

String updateRequestTrip = """
mutation  updateRequestTrip(
  \$id: ID!, 
  \$status: String!,   
){
  updateRequestTrip(
   data:{
     status: \$status,
     id:\$id
  } 
  ){
    response,
    message
  }
}
""";

String allRequestTrip = """
query {
  allRequestTrip {
    id
    user{
      firstName
      lastName
      phoneNumber
    }
    status
    pickupLocation{
      latitude
      longitude
    },endLocation{
      latitude,
      longitude
    },
  }
}
""";

String requestTripInfo = """
query{
  requestTripInfo {
    id
    status,
    endLocation{
      latitude,
      longitude
    },
    pickupLocation{
      latitude,
      longitude
    },
    date
  }
}
""";
