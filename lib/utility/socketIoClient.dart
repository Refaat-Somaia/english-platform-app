import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  String matchid = "";

  // Initialize socket in the constructor
  SocketService(
      {required this.updateLoading,
      required this.addAnswer,
      required this.addWord,
      required this.updatePlayers,
      required this.hasLost,
      required this.setFirst,
      required this.addPoints,
      required this.hasWon,
      required this.addSentence,
      required this.showAlert}) {
    socket = IO.io("http://192.168.1.110:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
  }
  final Function updateLoading;
  final Function addAnswer;
  final Function addSentence;
  final Function updatePlayers;
  final Function addWord;
  final Function setFirst;
  final Function hasWon;
  final Function addPoints;
  final Function hasLost;
  final Function showAlert;

  void connect() {
    if (socket.connected) {
      print("Already connected!");
      return; // Prevent reconnecting multiple times
    }

    socket.connect();

    socket.onConnect((_) {
      print("Connected to server");
    });

    // Remove previous listeners to avoid duplicates
    socket.off("sessionUpdate");
    socket.off("matchFound/wordPuzzle");
    socket.off("matchFound/bombRelay");
    socket.off("receiveMessage");
    socket.off("disconnect");
    socket.off("sendMessage");

    socket.on("sessionUpdate", (data) {
      print("Session Update: ${data['message']}");
      if (data['message'].toString().split(" ")[2] == "disconnected.")
        showAlert();
    });

    socket.on("matchFound/wordPuzzle", (data) {
      print(data["players"]);
      matchid = data["sessionId"];
      addWord(data["word"], data["definition"]);
      List<Player> players = [];
      for (int i = 0; i < data['players'].length; i++) {
        players.add(Player(name: data['players'][i], points: 0));
      }
      updatePlayers(players);
      updateLoading();
    });

    socket.on("matchFound/bombRelay", (data) {
      matchid = data["sessionId"];
      addWord(data["word"], data["definition"]);
      setFirst(data["first"]);
      List<Player> players = [];
      for (int i = 0; i < data['players'].length; i++) {
        players.add(Player(name: data['players'][i], points: 0));
      }
      updatePlayers(players);
      updateLoading();
    });

    socket.on("receiveMessage", (data) {
      if (data['sender'] == preferences.getString("userName")) return;
      print("Message Received from ${data['sender']}: ${data['message']}");
      switch (data['action']) {
        case "IWON":
          hasLost();
          break;
        case "ILOST":
          hasLost();
          break;
        case "points":
          addPoints(data["sender"], data["message"]);
          break;
        case "answer_bombRelay":
          addAnswer(data['message'].toString(), data['sender']);
          setFirst(true);
          break;
      }
    });

    socket.onDisconnect((_) {
      print("Disconnected from server");
    });
  }

  void createSession(String gameName) {
    socket.emit("createSession", gameName);
  }

  void joinSession(String sessionId) {
    socket.emit("joinSession", sessionId);
  }

  void leaveSession(String sessionId) {
    socket.emit("leaveSession", sessionId);
  }

  void sendMessage(String sessionId, String message, String action) {
    socket.emit("sendMessage", {
      "sessionId": sessionId,
      "sender": preferences.getString("userName"),
      "action": action,
      "message": message
    });
  }

  void findMatch(String gameName) {
    socket.emit(
        "findMatch/$gameName", {"userName": preferences.getString("userName")});
  }

  void disconnect() {
    socket.disconnect();
  }
}
