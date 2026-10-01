import 'package:flutter/material.dart';

import '../models/favorite_developer.dart';
import '../services/favorite_api_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  final FavoriteApiService apiService =
  FavoriteApiService();

  List<FavoriteDeveloper> favorites = [];

  bool loading = false;

  String? error;

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  Future<void> loadFavorites() async {

    setState(() {
      loading = true;
      error = null;
    });

    try {

      final result =
      await apiService.getFavorites();

      setState(() {
        favorites = result;
        loading = false;
      });

    } catch (e) {

      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> deleteFavorite(int id) async {

    try {

      await apiService.deleteFavorite(id);

      setState(() {
        favorites.removeWhere(
              (favorite) => favorite.id == id,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favorite removed'),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Favorite Developers'),
      ),

      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )

          : error != null
          ? Center(
        child: Text(
          error!,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
      )

          : favorites.isEmpty
          ? const Center(
        child: Text(
          'No favorite developers',
        ),
      )

          : ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: favorites.length,

        itemBuilder: (context, index) {

          final favorite =
          favorites[index];

          return Card(

            child: ListTile(

              leading: CircleAvatar(
                child: Text(
                  favorite.username
                      .isNotEmpty
                      ? favorite.username[0]
                      .toUpperCase()
                      : '?',
                ),
              ),

              title: Text(
                favorite.username,
              ),

              subtitle: Text(
                favorite.note,
              ),

              trailing: IconButton(

                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),

                onPressed: () {
                  deleteFavorite(
                    favorite.id,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}