getVechileImage({required carType}) {
  var logo = null;
  if (carType == "Sedan") {
    logo = "assets/images/sedan.png";
  } else if (carType == "SUV") {
    logo = "assets/images/car.png";
  } else if (carType == "Truck") {
    logo = "assets/images/truck.png";
  }
  return logo;
}
