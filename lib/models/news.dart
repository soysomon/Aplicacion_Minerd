class News {
  final String title;
  final String content;
  final String link;

  News({
    required this.title,
    required this.content,
    required this.link,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      link: json['link'],
    );
  }
}
