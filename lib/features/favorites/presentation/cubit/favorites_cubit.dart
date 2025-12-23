import 'package:bloc/bloc.dart';
import '../../../home/data/models/product_model.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesLoaded([]));

  final List<ProductModel> _favorites = [];

  void toggleFavorite(ProductModel product) {
    final index = _favorites.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(product);
    }
    emit(FavoritesLoading());
    emit(FavoritesLoaded(List.from(_favorites)));
  }

  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }
}
