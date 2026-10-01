import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_user.dart';
class GithubApiService {
  Future<GitHubUser> getUser(String username) async {
    final url = Uri.parse( 'https://api.github.com/users/$username', );
    final response = await http.get(url);
    if (response.statusCode == 200)
    {
      final data = jsonDecode(response.body);
      return GitHubUser.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else
    { throw Exception( 'Failed to load user. Status code: ${response.statusCode}', );
    }
  }
}