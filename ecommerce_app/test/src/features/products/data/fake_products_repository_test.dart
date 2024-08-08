import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository makeProductsRepository() =>
      FakeProductsRepository(addDelay: false);
  group('FakeProductsRepository', () {
    test('fetchProducts return global list of products', () async {
      final productsRepository = makeProductsRepository();
      expect(await productsRepository.fetchProducts(), kTestProducts);
    });

    test("getProduct return first item", () async {
      final productsRepo = makeProductsRepository();
      expect(productsRepo.getProduct(productId: "1"), kTestProducts[0]);
    });

    test('getProduct(100) return null', () async {
      final productsRepo = makeProductsRepository();
      expect(productsRepo.getProduct(productId: "100"), null);
    });

    test('watchProductList return global list of product', () {
      final productsRepo = makeProductsRepository();
      expect(productsRepo.watchProductList(), emits(kTestProducts));
    });

    test('watchProduct(1) return null', () {
      final productsRepo = makeProductsRepository();
      expect(
          productsRepo.watchProduct(productId: "1"), emits(kTestProducts[0]));
    });

    test('watchProduct(100) emits null', ()  {
      final productsRepo = makeProductsRepository();
      expect(productsRepo.watchProduct(productId: "100"), emits(null));
    });
  });
}
