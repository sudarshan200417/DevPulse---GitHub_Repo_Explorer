
class GitHubUser{
  final String login;
  final String avatarUrl;
  final String name;
  final int publicRepos;
  final int followers;
  final int following;
  
  GitHubUser({
    required this.login,
    required this.avatarUrl,
    required this.name,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });
  factory GitHubUser.fromJson(Map<String,dynamic> json){
    return GitHubUser(
      login: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      name: json['name'] ?? 'No name',
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }
}