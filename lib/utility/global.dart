import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/model/Chapter.dart';
import 'package:funlish_app/model/level.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primaryPurple = Color(0xff9E75FF);
const Color primaryBlue = Color(0xff4A85FC);
Color bodyColor = const Color(0xffF9F7FF);
Color fontColor = const Color(0xff32356D);
// const Color bodyColor = Color.fromARGB(255, 23, 16, 39);

// const Color fontColor = Color(0xffF9F7FF);

final player = AudioPlayer();

String serverIp = 'http://192.168.1.110:8055';
String gameServerIp = "https://funlish-games-server.onrender.com";
// String gameServerIp = "http://192.168.1.110:3000";
const List<Color> colors = [
  Color.fromARGB(255, 48, 212, 234),
  Color(0xffFFCC70),
  Color(0xffF875AA),
  Color(0xff0EB29A),
  Color(0xff86B6F6),
  Color(0xffE43F5A),
  Color.fromARGB(255, 227, 66, 255)
];
List<Chapter> chapters = [];
List<McqLevel> mcqLevels = [];
late SharedPreferences preferences;
Text setText(String text, FontWeight weight, double size, Color color,
    [isCenterd, isRtl]) {
  return Text(
    text,
    style: TextStyle(
        fontFamilyFallback: ['magnet', 'janna'],
        decorationStyle: TextDecorationStyle.solid,
        decorationColor: primaryPurple,
        decorationThickness: 2,
        fontSize: size,
        fontWeight: weight,
        color: color),
    textDirection: isRtl != null ? TextDirection.rtl : TextDirection.ltr,
    textAlign: isCenterd != null ? TextAlign.center : TextAlign.start,
  );
}

void playSound(String path) async {
  await player.play(AssetSource(path)); // Play asset file
}

ButtonStyle buttonStyle(double raduis) {
  return OutlinedButton.styleFrom(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(raduis))));
}

Map<String, IconData> houseWordsIcons = {
  "Attic": FontAwesomeIcons.houseChimney, // Represents the top of the house.
  "Basement":
      FontAwesomeIcons.building, // Generic building icon for underground space.
  "Balcony": FontAwesomeIcons.windowRestore, // Represents an open balcony.
  "Chimney":
      FontAwesomeIcons.fireFlameSimple, // Smoke icon to represent chimneys.
  "Living Room": FontAwesomeIcons.couch, // Classic couch for a living room.
  "Bedroom": FontAwesomeIcons.bed, // A bed for the bedroom.
  "Bathroom": FontAwesomeIcons.bath, // Bathtub icon for bathrooms.
  "Kitchen": FontAwesomeIcons.utensils, // Utensils for cooking in the kitchen.
  "Dining Room": FontAwesomeIcons.table, // Table for the dining room.
  "Porch": FontAwesomeIcons.sun, // Outdoor feel for the porch.
  "Garage": FontAwesomeIcons.car, // A car for the garage.
  "Garden": FontAwesomeIcons.seedling, // Plant icon for gardens.
  "Closet": FontAwesomeIcons.shirt, // A shirt for a clothing closet.
  "Pantry": FontAwesomeIcons.box, // A box for storing pantry items.
  "Hallway": FontAwesomeIcons.route, // A path for the hallway.
  "Roof": FontAwesomeIcons.house, // Generic house icon for the roof.
  "Staircase":
      FontAwesomeIcons.arrowUp, // Represents upward movement for stairs.
  "Floor": FontAwesomeIcons.borderAll, // A grid-like icon for floors.
  "Ceiling": FontAwesomeIcons.gripLines, // Horizontal lines for ceilings.
  "Wall": FontAwesomeIcons.braille, // Symbolizes walls with dots/structure.
  "Fireplace": FontAwesomeIcons.fire, // Fire icon for fireplaces.
  "Window": FontAwesomeIcons.windowMaximize, // Represents a window.
  "Door": FontAwesomeIcons.doorClosed, // A closed-door icon.
  "Curtains": FontAwesomeIcons.tableColumns, // Columns resemble curtains.
  "Carpet": FontAwesomeIcons.rug, // Rug icon for carpets.
  "Couch": FontAwesomeIcons.couch, // A couch icon.
  "Bookshelf": FontAwesomeIcons.book, // Books icon for bookshelves.
  "Table": FontAwesomeIcons.table, // Table icon.
  "Chair": FontAwesomeIcons.chair, // A chair icon.
  "Lamp": FontAwesomeIcons.lightbulb, // Lightbulb for lamps.
  "Study": FontAwesomeIcons.book,
  "Yard": Icons.yard,
  "Furniture": Icons.chair_outlined,
  "couch": Icons.chair,
  "Sink": Icons.water_drop_rounded,
  "Refrigerator": Icons.icecream_rounded,
};

Map<String, IconData> travelingWordsIcons = {
  "Passport": FontAwesomeIcons.passport,
  "Luggage": FontAwesomeIcons.suitcaseRolling,
  "Boarding Pass": FontAwesomeIcons.ticketAlt,
  "Itinerary": FontAwesomeIcons.mapMarkedAlt,
  "Souvenir": FontAwesomeIcons.gift,
  "Destination": FontAwesomeIcons.mapMarkerAlt,
  "Tourist": FontAwesomeIcons.user,
  "Accommodation": FontAwesomeIcons.hotel,
  "Jet Lag": FontAwesomeIcons.bed,
  "Currency Exchange": FontAwesomeIcons.moneyBillWave,
  "Travel Insurance": FontAwesomeIcons.shieldAlt,
  "Customs": FontAwesomeIcons.clipboardCheck,
  "Backpacking": FontAwesomeIcons.hiking,
  "Tour Guide": FontAwesomeIcons.userTie,
  "Road Trip": FontAwesomeIcons.carSide,
  "Airplane": FontAwesomeIcons.plane,
  "Hotel": FontAwesomeIcons.hotel,
  "Map": FontAwesomeIcons.map,
  "Suitcase": FontAwesomeIcons.suitcase,
  "Travel Agency": FontAwesomeIcons.briefcase,
  "Airline": Icons.corporate_fare_rounded,
  "Airport": Icons.airplanemode_active_rounded,
  "Runway": Icons.add_road_rounded,
  "Take-off": Icons.flight_takeoff_rounded
};
Map<String, IconData> healthcareWordsIcons = {
  "Doctor": FontAwesomeIcons.userDoctor,
  "Nurse": FontAwesomeIcons.userNurse,
  "Hospital": FontAwesomeIcons.hospital,
  "Pharmacy": FontAwesomeIcons.prescriptionBottleAlt,
  "Prescription": FontAwesomeIcons.fileMedical,
  "Ambulance": FontAwesomeIcons.ambulance,
  "Surgery": FontAwesomeIcons.handHoldingMedical,
  "Vaccine": FontAwesomeIcons.syringe,
  "Emergency Room": FontAwesomeIcons.procedures,
  "Pill": FontAwesomeIcons.pills,
  "Stethoscope": FontAwesomeIcons.stethoscope,
  "Medical Checkup": FontAwesomeIcons.notesMedical,
  "First Aid": FontAwesomeIcons.briefcaseMedical,
  "X-ray": FontAwesomeIcons.xRay,
  "Thermometer": FontAwesomeIcons.thermometer,
  "Blood Pressure Monitor": FontAwesomeIcons.heartbeat,
  "Dentist": FontAwesomeIcons.tooth,
  "Medicine": FontAwesomeIcons.pills,
  "Injection": FontAwesomeIcons.syringe,
  "Bandage": FontAwesomeIcons.bandage,
  "Health Insurance": FontAwesomeIcons.shieldAlt,
  "Optometrist": FontAwesomeIcons.glasses,
};

Map<String, IconData> educationWordsIcons = {
  "School": FontAwesomeIcons.school,
  "Teacher": FontAwesomeIcons.chalkboardTeacher,
  "Student": FontAwesomeIcons.userGraduate,
  "Classroom": FontAwesomeIcons.chalkboard,
  "Homework": FontAwesomeIcons.bookOpen,
  "Exam": FontAwesomeIcons.pencilAlt,
  "Library": FontAwesomeIcons.book,
  "Notebook": FontAwesomeIcons.fileAlt,
  "Pencil": FontAwesomeIcons.pencil,
  "Eraser": FontAwesomeIcons.eraser,
  "Subject": FontAwesomeIcons.book,
  "Desk": FontAwesomeIcons.table,
  "Whiteboard": FontAwesomeIcons.chalkboard,
  "Principal": FontAwesomeIcons.userTie,
  "Graduation": FontAwesomeIcons.graduationCap,
  "Scholarship": FontAwesomeIcons.moneyCheck,
  "Textbook": FontAwesomeIcons.bookReader,
  "Online Class": FontAwesomeIcons.laptop,
  "School Bus": FontAwesomeIcons.bus,
};

Map<String, Map<String, IconData>> chapterIcons = {
  'Healthcare': healthcareWordsIcons,
  'Traveling': travelingWordsIcons,
  'House': houseWordsIcons,
  'Education': educationWordsIcons,
};

List<String> getRandomWords(List<String> houseWords, String levelWord) {
  List<String> allWords = List.from(
      houseWords); // Create a copy to avoid modifying the original list

  allWords.remove(
      levelWord); // Ensure levelWord is not included in the random selection

  allWords.shuffle(Random()); // Shuffle before taking words

  List<String> randomWords =
      allWords.take(3).toSet().toList(); // Convert to Set to ensure uniqueness

  randomWords.add(levelWord); // Add the levelWord

  randomWords.shuffle(
      Random()); // Shuffle again to randomize the position of levelWord

  return randomWords;
}
