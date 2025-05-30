import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  String matchid = "";

  final Function updateLoading;
  final Function addAnswer;
  final Function addSentence;
  final Function updatePlayers;
  final Function addWord;
  final Function setFirst;
  final Function hasWon;
  final Function? setId;
  final Function? wordHint;

  final Function hasDraw;
  final Function addPoints;
  final Function hasLost;
  final Function friednlyBomb;
  final Function extendTimer;
  final Function showAlert;

  static String SERVER_URL = dotenv.env['GAME_SERVER_URL']!;

  SocketService({
    required this.updateLoading,
    required this.addAnswer,
    required this.friednlyBomb,
    this.setId,
    this.wordHint,
    required this.addWord,
    required this.extendTimer,
    required this.updatePlayers,
    required this.hasLost,
    required this.setFirst,
    required this.addPoints,
    required this.hasWon,
    required this.hasDraw,
    required this.addSentence,
    required this.showAlert,
  }) {
    socket = IO.io(SERVER_URL, {
      "transports": ["websocket"],
      "autoConnect": false,
    });
  }

  void connect() {
    if (socket.connected) {
      print("Already connected!");
      return;
    }

    socket.connect();
    socket.onConnect((_) => print("Connected to server"));
    socket.onDisconnect((_) => print("Disconnected from server"));
    socket.on("connect_error", (_) => print("Connection error, retrying..."));

    setupListeners();
  }

  void setupListeners() {
    socket.off("sessionUpdate");
    socket.off("matchFound/wordPuzzle");
    socket.off("matchFound/bombRelay");
    socket.off("receiveMessage");
    socket.off("matchFound/castleEscape");
    socket.off("sessionCreated");

    socket.on("sessionUpdate", (data) {
      if (data.containsKey('message') && data['message'] is String) {
        if (data['message'].split(" ").length > 2 &&
            data['message'].split(" ")[2] == "disconnected.") {
          showAlert();
        } else if (data.containsKey('id') && data['id'] is String) {
          if (setId != null) setId!(data['id']);
        }
      }
    });

    socket.on("sessionCreated", (data) {
      print(data);
      setId!(data["sessionId"]);
    });

    socket.on("matchFound/wordPuzzle", (data) {
      matchid = data["sessionId"];
      addWord(data["word"], data["definition"]);
      updatePlayers(parsePlayers(data['players']));
      updateLoading();
    });

    socket.on("matchFound/castleEscape", (data) {
      print(data["word"] + data["definition"] + data["options"]);
      matchid = data["sessionId"];
      addWord(data["word"], data["definition"], data["options"]);
      updatePlayers(parsePlayers(data['players']));
      updateLoading();
    });

    socket.on("matchFound/bombRelay", (data) {
      matchid = data["sessionId"];
      addWord(data["word"], data["definition"]);
      setFirst(data["first"]);
      updatePlayers(parsePlayers(data['players']));
      updateLoading();
    });

    socket.on("receiveMessage", (data) {
      String? sender = data['sender'];
      String? action = data['action'];
      String? message = data['message'];

      if (sender == preferences.getString("userName")) return;

      print("Message Received from $sender: $message");

      switch (action) {
        case "IWON":
          hasLost();
          break;
        case "ILOST":
          hasWon();
          break;
        case "DRAW":
          hasDraw();
          break;
        case "points":
          addPoints(sender, message);
          break;
        case "answer_bombRelay":
          addAnswer(message, sender);
          setFirst(true);
          break;
        case "EXTENDTIMER":
          extendTimer(sender);
          break;
        case "FRIENDLYBOMB":
          friednlyBomb(sender);
          break;
        case "WORDHINT":
          if (wordHint != null) wordHint!(sender);
          break;
        default:
          break;
      }
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
    String? userName = preferences.getString("userName");
    if (userName == null || userName.isEmpty) {
      print("Error: UserName is null or empty.");
      return;
    }

    socket.emit("sendMessage", {
      "sessionId": sessionId,
      "sender": userName,
      "action": action,
      "message": message
    });
  }

  void findMatch(String gameName) {
    String? userName = preferences.getString("userName");
    int? userLevel = preferences.getInt("userLevel") ?? 1;
    int? characterIndex = preferences.getInt("userCharacter") ?? 0;
    int? hatIndex = preferences.getInt("userHat") ?? 0;

    if (userName == null || userName.isEmpty) {
      print("Error: UserName is null or empty.");
      return;
    }

    socket.emit("findMatch/$gameName", {
      "userName": userName,
      'userLevel': userLevel,
      "characterIndex": characterIndex,
      "hatIndex": hatIndex
    });
  }

  void disconnect() {
    socket.disconnect();
  }

  List<Player> parsePlayers(List<dynamic> playerData) {
    print(playerData); // Debugging print
    return playerData.map((data) {
      return Player(
        name: data['userName'], // Extract name
        points: 0, // Default value
        characterIndex: data['characterIndex'] ?? 0, // Use default if missing
        hatIndex: data['hatIndex'] ?? 0, // Use default if missing
        level: data['userLevel'] ?? 0, // Use default if missing
      );
    }).toList();
  }
}
