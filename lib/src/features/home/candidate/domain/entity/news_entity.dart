import 'package:uuid/uuid.dart';

class NewsEntity {
  final UuidValue id;
  final String title;
  final String content;
  final DateTime publishedAt;

  NewsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
  });
}
