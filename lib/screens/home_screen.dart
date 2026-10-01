import 'package:devpluse_github_repo_explorer/screens/favorite_screen.dart';
import 'package:flutter/material.dart';

import '../models/github_user.dart';
import '../services/github_api_service.dart';
import '../services/favorite_api_service.dart';
import '../widgets/user_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller =
  TextEditingController();

  final GithubApiService apiService =
  GithubApiService();

  final FavoriteApiService favoriteApiService =
  FavoriteApiService();

  GitHubUser? user;

  bool loading = false;

  String? error;

  // GET - Search GitHub User
  Future<void> searchUser() async {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a GitHub username',
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      loading = true;
      error = null;
      user = null;
    });

    try {
      final result = await apiService.getUser(
        controller.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        user = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  // POST - Add Developer to Favorites
  Future<void> addToFavorites() async {
    if (user == null) {
      return;
    }

    try {
      await favoriteApiService.addFavorite(
        user!.login,
        'GitHub Developer',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Developer added to favorites',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // Open Favorites Screen
  void openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const FavoritesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.insights,
              size: 26,
            ),
            const SizedBox(width: 8),
            const Text('DevPulse'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: openFavorites,
            tooltip: 'Favorites',
            icon: const Icon(
              Icons.star_rounded,
              size: 28,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            24,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Discover GitHub Developers',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Search for a developer and explore their GitHub profile.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // Search Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      textInputAction:
                      TextInputAction.search,

                      decoration: InputDecoration(
                        labelText: 'GitHub Username',
                        hintText: 'Example: octocat',

                        prefixIcon: const Icon(
                          Icons.person_search_rounded,
                        ),

                        suffixIcon: IconButton(
                          onPressed: searchUser,
                          icon: const Icon(
                            Icons.search_rounded,
                          ),
                        ),
                      ),

                      onSubmitted: (_) {
                        searchUser();
                      },
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                        loading ? null : searchUser,

                        icon: const Icon(
                          Icons.search_rounded,
                        ),

                        label: const Text(
                          'Search Developer',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Loading
              if (loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 15),
                        Text(
                          'Fetching GitHub profile...',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Error
              if (error != null && !loading)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius:
                    BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red.shade100,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 42,
                        color: Colors.red.shade400,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

              // Developer Result
              if (user != null && !loading)
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Developer Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    UserCard(
                      user: user!,
                    ),

                    const SizedBox(height: 18),

                    // Add to Favorites
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: addToFavorites,

                        icon: const Icon(
                          Icons.star_rounded,
                        ),

                        label: const Text(
                          'Add to Favorites',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // View Favorites
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: openFavorites,

                        icon: const Icon(
                          Icons.favorite_rounded,
                        ),

                        label: const Text(
                          'View Favorite Developers',
                        ),
                      ),
                    ),
                  ],
                ),

              // Initial Empty State
              if (user == null &&
                  error == null &&
                  !loading)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.code_rounded,
                        size: 55,
                        color: Colors.indigo.shade400,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Start Exploring',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Enter a GitHub username above to view developer statistics.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}