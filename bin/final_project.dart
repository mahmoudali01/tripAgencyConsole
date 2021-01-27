import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';

class Trip {
  String _location;
  int _passengerLimit;
  String _date;
  double _price;
  static List allTrips = [];
  static List passengers = [];

  static int _id = 0;

  Trip();

  int get getId {
    return _id;
  }

  String get getLocation {
    return _location;
  }

  int get getPassengerLimit {
    return _passengerLimit;
  }

  String get getDate {
    return _date;
  }

  double get getPrice {
    return _price;
  }

  set setId(int id) {
    _id = id;
  }

  set setLocation(String location) {
    _location = location;
  }

  set setPassengerLimit(int pl) {
    _passengerLimit = pl;
  }

  set setDate(String date) {
    _date = date;
  }

  set setPrice(double price) {
    _price = price;
  }

  void addTrip(
    String location,
    int passengerLimit,
    String date,
    double price,
  ) {
    var idd = ++Trip._id;

    var trip =
        '{ "id" : "$idd" , "location" : "$location" , "passengerLimit": "$passengerLimit" , "date": "$date" , "price": "$price" }';
    var tripMap = jsonDecode(trip);
    print('Trip is Added Sucessfully');
    print(tripMap);
    allTrips.add(tripMap);
  }

  void editTrip(int id) {
    var found = 0;
    for (var trip in allTrips) {
      if (trip.containsKey('id')) {
        if (int.parse(trip['id']) == id) {
          found = 1;
        }
      }
    }
    if (found == 0) {
      print('id doesnt match with any trip');
    } else if (found == 1) {
      print('enter new trip location: ');
      var location = stdin.readLineSync();
      print('enter new trip date: ');
      var date = stdin.readLineSync();
      print('enter new trip price: ');
      var price = double.parse(stdin.readLineSync());
      print('enter new max trip number');
      var passengerLimit = int.parse(stdin.readLineSync());
      allTrips.forEach((element) {
        if (int.parse(element['id']) == id) {
          element['id'] = '$id';
          element['location'] = '$location';
          element['passengerLimit'] = '$passengerLimit';
          element['date'] = '$date';
          element['price'] = '$price';
          print('Trip is Edited Sucessfully');
        }
      });
    }
    //print('Trip is Edited Sucessfully');
  }

  void deleteTrip(int id) {
    var found = 0;
    var dindex;
    allTrips.asMap().forEach((i, trip) {
      if (int.parse(trip['id']) == id) {
        found = 1;
        dindex = i;
      }
      //print('index=$i, value=$trip');
    });
    // for (var trip in allTrips) {
    //   if (trip.containsKey('id')) {
    //     if (int.parse(trip['id']) == id) {
    //       found = 1;
    //     }
    //   }
    // }
    if (found == 0) {
      print('id doesnt match with any trip');
    } else if (found == 1) {
      allTrips.forEach((element) {
        if (int.parse(element['id']) == id) {
          element.clear();
          jsonEncode(element);
        }
      });

      // var dindex = --id;
      allTrips.removeAt(dindex);
      // allTrips.forEach((element) {
      //   var i = 0;
      //   ++i;
      //   element['id'] = '$i';
      // });
      print('Trip is Deleted Sucessfully');
    }
  }

  void viewTrips() {
    if (allTrips.isEmpty) {
      print('there is no trips');
    } else {
      print('Our Trips :');
      allTrips.forEach((element) {
        print(element);
      });
    }
  }

  void viewTripsByDate() {
    var trips = allTrips;

    for (var trip in trips) {
      var format = DateFormat('yyyy-MM-dd');
      format.parse(trip['date']);
    }
    trips.sort((a, b) {
      var adate = a['date'];
      var bdate = b['date'];
      return bdate.compareTo(adate);
    });
    if (trips.isEmpty) {
      print('there is no trips');
    } else {
      trips.forEach((element) {
        print(element);
      });
    }
  }

  void searchTrips(double price) {
    var searchResult = [];

    for (var trip in allTrips) {
      if (double.parse(trip['price']) == price) {
        searchResult.add(trip);
      }
    }
    if (searchResult.isEmpty) {
      print('there is no trip with this price');
    } else {
      searchResult.forEach((element) {
        print(element);
      });
    }
  }

  void reserveTrip(int id) {
    var found = 0;
    for (var trip in allTrips) {
      if (trip.containsKey('id')) {
        if (int.parse(trip['id']) == id) {
          found = 1;
        }
      }
    }
    if (found == 0) {
      print('id doesnt match with any trip');
    } else if (found == 1) {
      for (var trip in allTrips) {
        if (int.parse(trip['id']) == id) {
          if (int.parse(trip['passengerLimit']) > 0) {
            print('the trip is available for reservation');
            print('please fill this application to complete reservation');
            print('enter your name ');
            var name = stdin.readLineSync();
            print('enter your social security number ');
            var ssn = stdin.readLineSync();
            print('enter yoour phone number');
            var pnumber = stdin.readLineSync();
            print('enter payement method (visa/mastercard)');
            var pay = stdin.readLineSync();
            var newPS = int.parse(trip['passengerLimit']);
            --newPS;
            trip['passengerLimit'] = '$newPS';
            var idd = trip['id'];
            var passenger =
                '{ "tripid" : "$idd" , "name" : "$name" , "ssn": "$ssn" , "phoneNumber": "$pnumber" , "paymentMethod": "$pay" }';
            var passengerMap = jsonDecode(passenger);
            passengers.add(passengerMap);
            print('the trip is reserved sucessfully');
            if (double.parse(trip['price']) > 10000) {
              var bonus = double.parse(trip['price']) * 0.8;
              print('you got the bonus and u have to pay only $bonus');
            }
          } else {
            print('the trip is full');
          }
        }
      }
    }
  }

  //void reservationDetails(String name, String ssn, String pay) {}
  void viewLatestTrips() {
    if (allTrips.isEmpty) {
      print('there is no trips');
    } else if (allTrips.length <= 10 && allTrips.isNotEmpty) {
      print('last added trips : ');

      for (var i = 0; i < allTrips.length; i++) {
        print(allTrips[i]);
      }
    } else if (allTrips.length > 10) {
      var lastTen = allTrips.length - 10;
      print('last added trips : ');
      for (var i = lastTen; i < allTrips.length; i++) {
        print(allTrips[i]);
      }
    }
  }

  void viewAllPassengers() {
    if (passengers.isNotEmpty) {
      passengers.forEach((element) {
        print(element);
      });
    } else {
      print('there isnt any passengers');
    }
  }

  void viewPassenger(int tripID) {
    var searchResult = [];

    for (var passenger in passengers) {
      if (int.parse(passenger['tripid']) == tripID) {
        searchResult.add(passenger);
      }
    }
    if (searchResult.isEmpty) {
      print('there isnt any passengers on this trip yet');
    } else {
      searchResult.forEach((element) {
        print(element);
      });
    }
  }
}

void main() {
  var switchh = true;
  while (switchh == true) {
    print('hi this travelco agency');
    print('1- add a new trip');
    print('2- edit trip');
    print('3- delete trip');
    print('4- view trips by date');
    print('5- search trip by price');
    print('6- reserve a trip');
    print('7- last added trips');
    print('8- view passengers');
    print('9- exit');

    print('please select the number of your choice  from the above menu: ');
    var choice = int.parse(stdin.readLineSync());

    switch (choice) {
      case 1:
        {
          print('Please Enter Trip Details');
          print('enter trip location: ');
          var location = stdin.readLineSync();
          print('enter trip date(yyyy-mm-dd): ');
          var date = stdin.readLineSync();
          print('enter trip price: ');
          var price = double.parse(stdin.readLineSync());
          print('enter passengers limit for trip ');
          var pn = int.parse(stdin.readLineSync());
          var t = Trip();
          print('proceding . . . ');
          sleep(Duration(seconds: 3));
          t.addTrip(location, pn, date, price);

          var x = true;
          while (x == true) {
            print('1- add another trip');
            print('2- return to main menu');

            var choice = int.parse(stdin.readLineSync());

            switch (choice) {
              case 1:
                {
                  print('Please Enter Trip Details');
                  print('enter trip location: ');
                  var location = stdin.readLineSync();
                  print('enter trip date(yyyy-mm-dd): ');
                  var date = stdin.readLineSync();
                  print('enter trip price: ');
                  var price = double.parse(stdin.readLineSync());
                  print('enter passengers limit for trip ');
                  var pn = int.parse(stdin.readLineSync());
                  var t = Trip();
                  print('proceding . . . ');
                  sleep(Duration(seconds: 3));
                  t.addTrip(location, pn, date, price);
                }
                break;

              case 2:
                {
                  print('returning to main menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                  x = false;
                }

                break;
              default:
                {
                  print('Invalid choice');
                  sleep(Duration(seconds: 2));
                }
            }
          }
        }

        break;
      case 2:
        {
          var t2 = Trip();
          t2.viewTrips();
          print('Choose trip id to edit: ');
          var id = int.parse(stdin.readLineSync());
          print('proceeding . . . ');
          sleep(Duration(seconds: 2));
          t2.editTrip(id);
          t2.viewTrips();
          var x = true;
          while (x == true) {
            print('1- edit another trip');

            print('2- return to main menu');

            var choice = int.parse(stdin.readLineSync());

            switch (choice) {
              case 1:
                {
                  t2.viewTrips();
                  print('Choose trip id to edit: ');
                  var id = int.parse(stdin.readLineSync());
                  print('proceeding . . . ');
                  sleep(Duration(seconds: 2));
                  t2.editTrip(id);
                  t2.viewTrips();
                }

                break;
              case 2:
                {
                  print('returning to main menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                  x = false;
                }

                break;
              default:
                {
                  print('invaild choice');
                  sleep(Duration(seconds: 2));
                }
            }
          }
        }

        break;
      case 3:
        {
          var t3 = Trip();
          t3.viewTrips();
          print('Choose trip id to delete: ');
          var id = int.parse(stdin.readLineSync());
          print('proceeding . . . ');
          sleep(Duration(seconds: 2));
          t3.deleteTrip(id);
          t3.viewTrips();
          var x = true;
          while (x == true) {
            print('1- delete another trip');

            print('2- return to main menu');

            var choice = int.parse(stdin.readLineSync());

            switch (choice) {
              case 1:
                {
                  t3.viewTrips();
                  print('Choose trip id to delete: ');
                  var id = int.parse(stdin.readLineSync());
                  print('proceeding . . . ');
                  sleep(Duration(seconds: 2));
                  t3.deleteTrip(id);
                  t3.viewTrips();
                }

                break;
              case 2:
                {
                  print('returning to main menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                  x = false;
                }

                break;
              default:
                {
                  print('invaild choice');
                  sleep(Duration(seconds: 2));
                }
            }
          }
        }

        break;
      case 4:
        {
          var t4 = Trip();
          print('Trips by Date: ');

          t4.viewTripsByDate();
          //print('returning to main menu in 5 seconds . . . ');

          // sleep(Duration(seconds: 5));
          var x = true;
          while (x == true) {
            print('enter 1 return to main menu');

            var choice = int.parse(stdin.readLineSync());

            switch (choice) {
              case 1:
                {
                  print('returning to main menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                  x = false;
                }

                break;
              default:
                {
                  print('invaild choice');
                  sleep(Duration(seconds: 2));
                }
            }
          }
        }

        break;
      case 5:
        {
          var t5 = Trip();
          print('Enter the preice of trips u want: ');
          var price = double.parse(stdin.readLineSync());
          print('proceeding. . . ');

          sleep(Duration(seconds: 2));
          t5.searchTrips(price);
          var x = true;
          while (x == true) {
            print('1- search another trip');

            print('2- return to main menu');

            var choice = int.parse(stdin.readLineSync());

            switch (choice) {
              case 1:
                {
                  print('Enter the preice of trips u want: ');
                  var price = double.parse(stdin.readLineSync());
                  print('proceeding. . . ');

                  sleep(Duration(seconds: 2));
                  t5.searchTrips(price);
                }

                break;
              case 2:
                {
                  print('returning to main menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                  x = false;
                }

                break;
              default:
                {
                  print('invaild choice');
                  sleep(Duration(seconds: 2));
                }
            }
          }
        }

        break;

      case 6:
        {
          var t6 = Trip();
          t6.viewTrips();
          print('You can reserve any of them knowing that');
          print(
              'there is an offer of 20 % for the reservations above 10000 LE');
          print('Please enter the id of the trip u want to reserve: ');
          var id = int.parse(stdin.readLineSync());
          print('proceeding . . . ');

          sleep(Duration(seconds: 2));
          t6.reserveTrip(id);
          var x = true;
          while (x == true) {
            print('1- reserve another trip');

            print('2- return to main menu');

            var choice = int.parse(stdin.readLineSync());

            switch (choice) {
              case 1:
                {
                  t6.viewTrips();
                  print('You can reserve any of them knowing that');
                  print(
                      'there is an offer of 20 % for the reservations above 10000 LE');
                  print('Please enter the id of the trip u want to reserve: ');
                  var id = int.parse(stdin.readLineSync());
                  print('proceeding . . . ');

                  sleep(Duration(seconds: 2));
                  t6.reserveTrip(id);
                }

                break;
              case 2:
                {
                  print('returning to main menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                  x = false;
                }

                break;
              default:
                {
                  print('invaild choice');
                  sleep(Duration(seconds: 2));
                }
            }
          }
        }

        break;
      case 7:
        {
          var t7 = Trip();
          print('proceeding . . . ');
          sleep(Duration(seconds: 2));
          t7.viewLatestTrips();

          var x = true;
          while (x == true) {
            print('enter 1 return to main menu');

            var choice = int.parse(stdin.readLineSync());

            switch (choice) {
              case 1:
                {
                  print('returning to main menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                  x = false;
                }

                break;
              default:
                {
                  print('invaild choice');
                  sleep(Duration(seconds: 2));
                }
            }
          }
        }
        break;
      case 8:
        {
          var t8 = Trip();
          var x = true;
          while (x == true) {
            print('1-all passengers');
            print('2-specfic trip passengers');
            print('3-return to main menu');

            print(
                'please select the number of your choice from the above menu: ');
            var choice = int.parse(stdin.readLineSync());

            switch (choice) {
              case 1:
                {
                  print('proceeding . . . ');
                  sleep(Duration(seconds: 2));
                  t8.viewAllPassengers();
                }
                break;
              case 2:
                {
                  t8.viewTrips();
                  print('enter the trip id: ');
                  var tripId = int.parse(stdin.readLineSync());
                  print('proceeding . . . ');
                  sleep(Duration(seconds: 2));
                  t8.viewPassenger(tripId);
                }
                break;
              case 3:
                {
                  print('returning to main menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                  x = false;
                }

                break;
              default:
                {
                  print('Invalid choice');
                  print('returning to passenger menu in 2 seconds . . . ');
                  sleep(Duration(seconds: 2));
                }
            }
          }

          // t7.viewLatestTrips();
        }
        break;
      case 9:
        {
          print('Exiting our application . . . ');

          sleep(Duration(seconds: 2));
          switchh = false;
        }
        break;

      default:
        {
          print('Invalid choice');

          print('returning to main menu in 2 seconds . . . ');
          sleep(Duration(seconds: 2));
        }
    }
  }
}
