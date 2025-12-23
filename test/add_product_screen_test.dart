import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopio_app/features/admin/data/repositories/product_repository_impl.dart';
import 'package:shopio_app/features/home/data/models/product_model.dart';
import 'package:shopio_app/features/admin/presentation/pages/add_product_screen.dart';
import 'package:shopio_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shopio_app/features/home/domain/repositories/home_repository.dart';

// Simple Mock Repository
class MockProductRepository extends ProductRepositoryImpl {
  MockProductRepository() : super(remoteDataSource: null as dynamic);
  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    return;
  }
}

class MockHomeCubit extends Cubit<HomeState> implements HomeCubit {
  MockHomeCubit() : super(HomeInitial());

  @override
  final ProductRepository productRepository = MockProductRepository();
  @override
  final HomeRepository homeRepository = 0 as dynamic;

  @override
  void addProduct(ProductModel product) {}

  @override
  Future<void> loadHomeData() async {}

  @override
  Future<void> deleteProduct(String id) async {}

  @override
  Future<void> filterByCategory(String category) async {}

  @override
  Future<void> searchProducts(String query) async {}
}

void main() {
  testWidgets('AddProductScreen renders and submits', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [BlocProvider<HomeCubit>(create: (_) => MockHomeCubit())],
        child: RepositoryProvider<ProductRepositoryImpl>(
          create: (_) => MockProductRepository(),

          child: ScreenUtilInit(
            child: const MaterialApp(home: AddProductScreen()),
          ),
        ),
      ),
    );

    expect(find.text('Add New Product'), findsOneWidget);
    expect(find.text('Submit Product'), findsOneWidget);

    await tester.enterText(find.byIcon(Icons.title), 'Test Product');
    await tester.enterText(
      find.byIcon(Icons.description_outlined),
      'Test Description',
    );
    await tester.enterText(find.byIcon(Icons.inventory_2_outlined), '10');
    await tester.enterText(find.byIcon(Icons.attach_money), '99.99');
    await tester.enterText(
      find.byIcon(Icons.image_outlined),
      'http://image.com',
    );

    await tester.pump();

    await tester.tap(find.text('Submit Product'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  });
}
