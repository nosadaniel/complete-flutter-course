import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  testWidgets('leave review screen ...', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();

    r.products.expectFindAllProductCards();
    // * add to cart flows
    //select a product, default is first product
    await r.products.selectProduct();
    //set quantity
    await r.products.setProductQuantity(2);
    //add to cart
    await r.cart.addToCart();
    //open cart
    await r.cart.openCart();
    //expect to find a single cartItem
    r.cart.expectFindNCartItems(1);
    //close shopping cart screen
    await r.closePage();
    //open popup menu
    await r.openPopupMenu();
    // open signIn screen
    await r.auth.openEmailPasswordSignInScreen();
    // toggle to create account
    await r.auth.toggleToRegisterAccount();
    // sigin with email and password
    await r.auth.signInWithEmailAndPassword();
    //expect to be returned to home
    r.products.expectFindAllProductCards();
    // check cart again (to verify cart synchronization )
    await r.cart.openCart();
    r.cart.expectFindNCartItems(1);
    await r.checkout.startCheckout();
    r.checkout.expectPayButtonFound();
    await r.checkout.startPayment();
    //when payment is completed the user is
    // taken to the orders page
    r.orders.expectFindNOrders(1);
    await r.closePage();
    //close orders page
    //check that cart is now empty
    await r.cart.openCart();
    r.cart.expectShoppingCartIsEmpty();
    await r.closePage();
    //review flow
    await r.products.selectProduct();
    r.reviews.expectFindLeaveReview();
    await r.reviews.tapLeaveReviewButton();
    await r.reviews.createAndSubmitReview("good product");
    // r.reviews.expectFindOneReview();
  });
}
