class LessonPage {
  final String title;
  final String content;
  final List<String> keyPoints;

  LessonPage({
    required this.title,
    required this.content,
    required this.keyPoints,
  });
}

class Lesson {
  final String subject;
  final String title;
  final List<LessonPage> pages;

  Lesson({
    required this.subject,
    required this.title,
    required this.pages,
  });
}
