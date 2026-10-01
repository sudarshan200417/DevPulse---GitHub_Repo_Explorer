import 'package:devpluse_github_repo_explorer/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import '../models/github_user.dart';

class UserCard extends StatelessWidget {
  final GitHubUser user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),

            const SizedBox(height: 15),

            // Name
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // Username
            Text(
              '@${user.login}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                StatsCard(
                  title: 'Repositories',
                  value: user.publicRepos.toString(),
                ),

                StatsCard(
                  title: 'Followers',
                  value: user.followers.toString(),
                ),

                StatsCard(
                  title: 'Following',
                  value: user.following.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}