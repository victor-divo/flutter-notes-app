// The Note class represents a note with fields like id, title, content, and timestamps.
class Note {
  int? id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructor for creating a new Note object. If no date is provided, it defaults to the current date and time.
  Note({
    this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Converts the Note object into a Map for storage or database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Creates a Note object from a Map (e.g., fetched from a database or API)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Returns a new Note object with updated fields, if provided
  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Returns the createdAt field as a formatted string (e.g., "dd/mm/yyyy hh:mm")
  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute}';
  }

  // Returns the updatedAt field as a formatted string (e.g., "dd/mm/yyyy hh:mm")
  String get formattedUpdatedAt {
    return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year} ${updatedAt.hour}:${updatedAt.minute}';
  }
}
