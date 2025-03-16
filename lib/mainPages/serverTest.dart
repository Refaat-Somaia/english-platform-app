// import 'package:flutter/material.dart';
// import 'package:funlish_app/utility/socketIoClient.dart';

// class Servertest extends StatefulWidget {
//   @override
//   _ServertestState createState() => _ServertestState();
// }

// class _ServertestState extends State<Servertest> {
//   final SocketService socketService = SocketService(
//       updateLoading: () {},
//       addWord: () {},
//       addAnswer: () {},
//       hasLost: () {},
//       addSentence: () {},
//       showAlert: () {}); // Use the singleton instance
//   final TextEditingController sessionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     socketService.connect();
//   }

//   @override
//   void dispose() {
//     socketService.disconnect();
//     super.dispose();
//   }

//   String matchId = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Socket.io Game")),
//       body: Column(
//         children: [
//           TextField(
//             controller: sessionController,
//             decoration: InputDecoration(labelText: "Session ID"),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   socketService.createSession(sessionController.text);
//                 },
//                 child: Text("Create"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   socketService.joinSession(sessionController.text);
//                 },
//                 child: Text("Join"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   socketService.leaveSession(sessionController.text);
//                 },
//                 child: Text("Leave"),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   socketService.findMatch("");
//                 },
//                 child: Text("random"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   print(socketService.matchid);
//                   socketService.sendMessage(
//                       socketService.matchid, "ballafladj", "");
//                 },
//                 child: Text("send"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
