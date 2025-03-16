import 'package:get/get.dart';
import 'package:funlish_app/model/Chapter.dart';

import '../utility/databaseHandler.dart';

class ChapterController extends GetxController {
  final RxList<Chapter> chapters = <Chapter>[].obs;

  Future<void> fetchChaptersFromDB() async {
    try {
      final newChapters = await getChaptersFromDB();
      chapters.value = newChapters;
    } catch (e) {
      print("Error fetching chapters: $e");
    }
  }

  void updateChapter(Chapter newChapters) {
    for (Chapter c in chapters) {
      if (newChapters.id == c.id) {
        c = newChapters;
      }
    }
    chapters.refresh();
  }
}
