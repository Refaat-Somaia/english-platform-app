import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/model/Chapter.dart';
import 'package:funlish_app/model/level.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primaryPurple = Color(0xff9E75FF);
const Color primaryBlue = Color(0xff4A85FC);
const Color bodyColor = Color(0xffF9F7FF);
const Color fontColor = Color(0xff32356D);
String serverIp = 'http://192.168.1.110:8055';
String gameServerIp = "http://192.168.1.110:3000";
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

const Map<String, String> houseWords = {
  "Attic":
      "A space or room just below the roof of a house, often used for storage.",
  "Basement":
      "A part of a building that is entirely or partly below ground level.",
  "Balcony":
      "A platform enclosed by a wall or railing, projecting from a building.",
  "Chimney":
      "A vertical structure that allows smoke and gases to escape from a fireplace or furnace.",
  "Living Room":
      "A room in a house for general everyday use, often for relaxing and entertaining guests.",
  "Bedroom":
      "A room used for sleeping, typically containing a bed and storage furniture.",
  "Bathroom":
      "A room containing a bath or shower and typically also a sink and toilet.",
  "Kitchen":
      "A room where food is prepared and cooked, often equipped with appliances.",
  "Dining Room":
      "A room where meals are eaten, often featuring a dining table and chairs.",
  "Porch":
      "A covered area at the entrance of a house, often open to the outside.",
  "Garage": "A building or part of a building for housing vehicles.",
  "Garden":
      "An outdoor area with plants, flowers, and trees, often adjacent to a house.",
  "Closet":
      "A small room or space used for storing clothes and other belongings.",
  "Pantry":
      "A small room or closet where food, dishes, and kitchen supplies are stored.",
  "Hallway": "A corridor in a house or building that leads to different rooms.",
  "Roof": "The top covering of a building that protects it from the weather.",
  "Staircase":
      "A set of stairs inside or outside a building that connects different floors.",
  "Floor": "The flat surface of a room on which you walk.",
  "Ceiling": "The overhead surface of a room, opposite the floor.",
  "Wall":
      "A vertical structure that encloses or divides a space in a building.",
  "Fireplace":
      "A structure for containing a fire, typically in a living room, for heating or decoration.",
  "Window":
      "An opening in the wall of a building that allows light and air to enter.",
  "Door":
      "A movable barrier that allows entry or exit from a room or building.",
  "Curtains":
      "Fabric coverings that are hung on windows for privacy or decoration.",
  "Carpet":
      "A thick, soft covering for the floor, typically made of fabric or fibers.",
  "Couch":
      "A long, upholstered seat for multiple people, commonly found in living rooms.",
  "Bookshelf": "A piece of furniture with shelves for storing books.",
  "Table":
      "A flat surface supported by legs, used for various activities like eating or working.",
  "Chair":
      "A piece of furniture for one person to sit on, typically with four legs and a backrest.",
  "Lamp": "A device for producing light, often used on tables or floors.",
};

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

Map<String, String> travelingWords = {
  "Passport": "An official document needed to travel to another country.",
  "Luggage": "Bags and suitcases you take with you on a trip.",
  "Boarding Pass": "A ticket that lets you get on a plane.",
  "Itinerary": "A plan that shows your travel schedule and activities.",
  "Souvenir": "Something you buy to remember a trip or place.",
  "Destination": "The place you are traveling to.",
  "Tourist": "A person who visits places for fun or exploration.",
  "Accommodation": "A place where you stay during your trip, like a hotel.",
  "Jet Lag":
      "Feeling tired because of traveling to a place in a different time zone.",
  "Currency Exchange":
      "Changing your money into the money used in another country.",
  "Travel Insurance":
      "A plan that protects you in case of problems while traveling.",
  "Customs": "An airport check for goods and luggage when entering a country.",
  "Backpacking": "Traveling with only a backpack and a few essentials.",
  "Tour Guide": "A person who shows you around and explains places.",
  "Road Trip": "A long journey by car.",
  "Airplane":
      "A vehicle that flies in the air to take people to faraway places.",
  "Hotel": "A place to stay while traveling, often with food and services.",
  "Map": "A drawing that shows you where to go.",
  "Suitcase": "A large bag to carry clothes and belongings.",
  "Travel Agency": "A business that helps you plan and book trips.",
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

Map<String, String> healthcareWords = {
  "Doctor":
      "A medical professional who helps people stay healthy and treats illnesses.",
  "Nurse": "A healthcare worker who cares for patients and helps doctors.",
  "Hospital": "A place where sick or injured people go to get medical care.",
  "Pharmacy": "A place where you can buy medicine prescribed by a doctor.",
  "Prescription":
      "A written note from a doctor to get medicine from a pharmacy.",
  "Ambulance":
      "A special vehicle that takes sick or injured people to the hospital.",
  "Surgery": "An operation done by doctors to fix or remove a health problem.",
  "Vaccine":
      "A medicine that protects you from getting sick from certain diseases.",
  "Emergency Room":
      "A hospital area where serious injuries or sudden illnesses are treated quickly.",
  "Stethoscope":
      "A tool used by doctors to listen to your heartbeat or breathing.",
  "Medical Checkup": "A visit to the doctor to check if you are healthy.",
  "First Aid":
      "Basic help given to someone who is sick or hurt before a doctor arrives.",
  "X-ray":
      "A picture of the inside of your body, used to check for broken bones or other problems.",
  "Thermometer": "A tool used to check your body temperature.",
  "Blood Pressure Monitor":
      "A device that measures how hard your blood pushes inside your body.",
  "Dentist": "A doctor who takes care of your teeth and gums.",
  "Medicine": "A substance that helps treat or cure illnesses.",
  "Injection": "Medicine that is given to your body using a needle.",
  "Bandage": "A piece of cloth used to cover a wound.",
  "Health Insurance": "A plan that helps pay for your medical care.",
  "Optometrist": "A doctor who checks and helps you with your eyesight.",
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

Map<String, String> educationWords = {
  "School": "A place where students go to learn.",
  "Teacher": "A person who helps students learn and understand things.",
  "Student": "A person who goes to school or studies.",
  "Classroom": "A room in a school where lessons take place.",
  "Homework": "Work given by teachers to do at home.",
  "Exam": "A test to check what you’ve learned.",
  "Library": "A place where you can borrow books to read or study.",
  "Notebook": "A book where you write down notes and ideas.",
  "Pencil": "A tool used for writing or drawing.",
  "Eraser": "A small object used to remove pencil marks.",
  "Subject": "A topic or area of study like math or science.",
  "Desk": "A table where you sit and do work or study.",
  "Whiteboard": "A board that teachers use to write on during lessons.",
  "Principal": "The head of a school.",
  "Graduation": "A ceremony when students finish school or college.",
  "Scholarship": "Money given to students to help pay for their studies.",
  "Textbook": "A book used for learning a subject.",
  "Online Class": "A class you attend using the internet.",
  "School Bus": "A bus that takes students to and from school.",
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
