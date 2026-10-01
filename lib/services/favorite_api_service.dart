import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/favorite_developer.dart';

class FavoriteApiService{
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com';
  Future<List<FavoriteDeveloper>> getFavorites() async {

    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
    );

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      return data.take(10).map((json) {
        return FavoriteDeveloper(
          id: json['id'],
          username: 'developer_${json['userId']}',
          note: json['title'],
        );
      }).toList();

    } else {

      throw Exception('Failed to load favorites');
    }
  }
Future<FavoriteDeveloper> addFavorite(String username,String note,)async{
  final response = await http.post(
    Uri.parse('$baseUrl/posts'),
    headers: {
      'Content-Type' : 'application/json',
    },
    body: jsonEncode({
      'username' : username,
      'note' : note,
    }),
  );

  if(response.statusCode==201){
    final data = jsonDecode(response.body);
    return FavoriteDeveloper.fromJson(data);
  }else{
    throw Exception('Failed to add Favorite');
  }
}
Future<FavoriteDeveloper> updateFavorite(int id,String note)async{
    final response = await http.patch(
        Uri.parse('$baseUrl/posts/$id'),
    headers:{
      'Content-Type':'Appication/json',

  },
  body: jsonEncode({
    'note' :note,
  }),
  );
    if(response.statusCode==200){
       final data = jsonDecode(response.body);
       return FavoriteDeveloper(
         id : id,
         username:data['username'] ?? '',
         note:data['note'] ?? note,
       );
    }else{
      throw Exception('Failed to update favorite');
    }
}
  Future<void> deleteFavorite(int id) async {

    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
    );

    if (response.statusCode != 200) {

      throw Exception('Failed to delete favorite');
    }
  }

}
