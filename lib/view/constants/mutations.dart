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
String allSkills = """
query {
allSkills {
id,
name
}
}
""";

String createDriver = """
mutation createDriver(
  \$user: ID!,
  \$address:String!,
  \$skills:[ID]!,
  \$license:Upload!,
  ){
   createDriver(data: {
    user:\$user,
    address:\$address,
    skills: \$skills
  },
   license:\$license
  ) {
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
    phoneNumber,
    isActive,
    profilepictureSet{
      image, 
    },
    driverSet{
      active,
      id,
      skills{
        name
      },
      drivervehicleSet{ 
        registrationPlate,
        modelName,
        modelColor,
        image
      }
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
  \$image: Upload!,
){
  addDriverVehicle(data: {
    vehicleClass: \$vehicleClass
    driver:  \$driver,
    modelName: \$modelName,
    modelColor: \$modelColor,
    insuranceDate: \$insuranceDate,
    roadTaxDate: \$roadTaxDate,
    registrationPlate: \$registrationPlate,
  },
  image: \$image
  ){
    response
    message
  }
}
""";

String allVehicleClass = """
query {
  allVehicleClass{
    id,
    name
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
  \$startNameLocation: String!, 
  \$startLatitude: String!, 
  \$startLongitude: String!, 
  \$endNameLocation: String!, 
  \$endLatitude: String!, 
 \$endLongitude: String!, 
){
  addRequestTrip(
   data:{
     user:\$user,
     status:\$status
  },
    pickupLocation:{
      name:\$startNameLocation,
      latitude:\$startLatitude,
      longitude:\$startLongitude
    },
     endLocation:{
      name:\$endNameLocation,
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
    id,
    vehicleClass{
      name
      vehiclebasepriceSet{
        price,
        rate
      }
    }
    type,
    user{
      firstName,
      lastName,
      phoneNumber,
      profilepictureSet{
        image, 
      },
    }
    status
    pickupLocation{
      latitude
      longitude
      name
    },endLocation{
      latitude,
      longitude
      name
    },
    businessrequesttripSet{
      tripDescription, 
      skills{
        id,
        name
      },
      file
    }
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

String addAcceptTrip = """
mutation  addAcceptTrip(
  \$requestTripId: ID!, 
  \$driverId: ID!,   
){
  addAcceptTrip(
   data:{
     requestTripId: \$requestTripId,
     driverId:\$driverId
  } 
  ){
    response,
    message,
    acceptTrip{
      id
    }
  }
}
""";

String addTrip = """
mutation addTrip(\$acceptId: ID!,
 \$endLocationName: String!, 
 \$endLocationLatituide: String!, 
 \$endLocationLongitude: String!, 
 \$startLocationName: String!, 
 \$startLocationLatituide: String!,
  \$startLocationLongitude: String!) {
  addTrip(
    data: {
      acceptId: \$acceptId
      }, 
      endLocation: {
        name: \$endLocationName,
        latitude: \$endLocationLatituide, 
        longitude: \$endLocationLongitude
      }, 
      startLocation: {
        name: \$startLocationName,
        latitude: \$startLocationLatituide, 
        longitude: \$startLocationLongitude
      }) {
    response
    message
    trip {
      id
    }
  }
}
""";

String forgotPassword = """
mutation  forgotPassword(
  \$email: String!,   
){
  forgotPassword(
    data:{
      phoneNumber:\$email
    }
  ){
    response,
    message, 
  }
}
""";

String resetPassword = """
mutation  resetPassword(
  \$email: String!, 
  \$otp: String!,
  \$password1: String!,
  \$password2: String!
){ 
  resetPassword(
    data:{
      phoneNumber:\$email,
      otp:\$otp,
      password1:\$password1,
      password2:\$password2
    }
  ){
    response,
    message, 
  }
}
""";

String allMyTrips = """
query{
  allMyTrips{
    start{
      name
    }
    end{
      name
    },
    createdDate,
    amount,
    modifiedDate,
    driverratingsSet{
      rateLevel
    }
  }
}
""";

String driverTripsSelection = """
query{
 b2bTrips {
   start{
      name
    }
    end{
      name
    },
    createdDate,
    amount,
    modifiedDate,
    driverratingsSet{
      rateLevel
    }
},
   c2bTrips {
   start{
      name
    }
    end{
      name
    },
    amount,
    createdDate,
    modifiedDate,
    driverratingsSet{
      rateLevel
    }
 }
}
""";

String driverStats = """
query{
  totalTrips, 
  availableBalance,
  tripAcceptanceRate,
  totalTripCanceled,
  registeredDate,
  totalEarnings,
   driverDepartment{
    name,
    business {
      name
    }
  },
   driverSkills {
    name
  }
}
""";

String uploadProfilePicture = """
mutation  uploadProfilePicture(
  \$user: ID!, 
  \$image: Upload!, 
){
  uploadProfilePicture(
   data:{
     user:\$user, 
   }, 
   image:\$image
  ){
    success,
    profilePicture{image}
  }
}
""";

String dateFilter = """
query uploadProfilePicture(
  \$filter: String!, 
){ 
  dateFilter(period: \$filter){
    start{
      name
    }
    end{
      name
    },
    createdDate,
    modifiedDate,
    amount,
    driverratingsSet{
      rateLevel
    }
	}
}

 
""";

String updateAccount = """
 mutation  uploadProfilePicture(
  \$userId: ID!, 
  \$firstName: String!, 
  \$lastName: String!, 
  \$email: String!, 
){
  updateAccount(
   data:{
    userId:\$userId, 
    firstName:\$firstName, 
    lastName:\$lastName,
    email:\$email,
  }
  ){
    response,
    message
  }
}
""";

String updateTrip = """
 mutation  updateTrip(
  \$tripId: ID!, 
  \$amount: String!, 
  \$distance: Int!,  
  \$name:String!,
  \$latitude: String!,
  \$longitude: String!
){
  updateTrip(
   data:{
    tripId:\$tripId, 
    amount:\$amount, 
    distance:\$distance, 
  },
  endLocation:{
    name:\$name,
    latitude:\$latitude,
    longitude:\$longitude
  }
  ){
    response,
    message
  }
}
""";
