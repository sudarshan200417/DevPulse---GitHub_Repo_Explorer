class FavoriteDeveloper{
  final int id;
  final String username;
  final String note;

  FavoriteDeveloper({
    required this.id,
    required this.username,
    required this.note,
  });

  factory FavoriteDeveloper.fromJson(Map<String,dynamic> json){
    return FavoriteDeveloper(
        id: json['id'] ?? 0,
        username: json['username'] ?? '',
        note: json['note'] ?? '',);
  }
  Map<String ,dynamic> toJson(){
    return{
      'username' : username,
      'note' : note,
    };
  }
}
