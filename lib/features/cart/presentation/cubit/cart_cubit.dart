import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';
import '../../../home/data/models/product_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartItemModel> _items = [
    
  ];

  void loadCart() {
    emit(CartLoading());
    // Simulate delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _emitLoaded();
    });
  }

  void addToCart(ProductModel product, int quantity) {
    final existingIndex = _items.indexWhere((i) => i.product.id == product.id);
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItemModel(product: product, quantity: quantity));
    }
    _emitLoaded();
  }

  void incrementQuantity(String productId) {
    if (state is CartLoaded) {
      final item = _items.firstWhere((e) => e.product.id == productId);
      item.quantity++;
      _emitLoaded();
    }
  }

  void decrementQuantity(String productId) {
    if (state is CartLoaded) {
      final item = _items.firstWhere((e) => e.product.id == productId);
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _items.remove(item);
      }
      _emitLoaded();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((e) => e.product.id == productId);
    _emitLoaded();
  }

  void _emitLoaded() {
    double total = 0;
    for (var item in _items) {
      total += item.totalPrice;
    }
    emit(CartLoaded(items: List.from(_items), totalAmount: total));
  }
}
