import 'dart:async';

import 'package:funlish_app/model/player.dart';

class Match {
  Timer timer = Timer(Duration(), () {});
  Timer timerPreMatch = Timer(Duration(), () {});
  List<Player> players = [];
  bool isLoading = true;
  bool isTimeUp = false;
  bool isCountDown = false;
  bool isWon = false;
  bool isLost = false;
  bool isDraw = false;
}
