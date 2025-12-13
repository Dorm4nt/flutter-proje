// lib/models/pokemon_figure.dart
class PokemonFigure {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;
  bool isFavorite;

  PokemonFigure({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    this.isFavorite = false,
  });
}
