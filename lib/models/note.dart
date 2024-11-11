class Note {
  int? id;
  String title;
  String content;
  DateTime createdAt;
  int color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.color,
  });

  // Convert a Note to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
    };
  }

  // Convert a Map to a Note
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      color: map['color'],
    );
  }
}
