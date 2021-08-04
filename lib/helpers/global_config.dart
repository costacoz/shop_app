import 'dart:convert';

class GlobalConfig {
  static const appFirebaseUrl = '**your url*';

  static const firebaseApiKey = '***your key**';

  static const restAuthBaseUrl = 'identitytoolkit.googleapis.com';

  static const signupPath = '/v1/accounts:signUp';
  static const signinPath = '/v1/accounts:signInWithPassword';

  static const productsPath = '/products.json';
  static const cartPath = "/cart.json";

  static Uri getUriByProductId(String id, String? token) {
    if (token == null) throw Exception('No Token provided!');
    return Uri.https(appFirebaseUrl, '/products/$id.json', {'auth': token});
  }

  static Uri getUriUserIsFavoriteForProduct({required String productId, String? token, String? userId}) {
    if ([productId, token, userId].contains(null)) throw Exception('No Token provided!');
    return Uri.https(appFirebaseUrl, '/userFavorites/$userId/$productId.json', {'auth': token});
  }

  static Uri getUriUserFavorites(String? token, String? userId) {
    checkTokenAndUserIdNotNull(token, userId);
    return Uri.https(appFirebaseUrl, '/userFavorites/$userId.json', {'auth': token});
  }

  static Uri getProductsUri(String? token, [Map filters = const {}]) {
    if (token == null) throw Exception('No Token or User Id provided!');
    return Uri.https(appFirebaseUrl, productsPath, {
      'auth': token,
      ...filters
    });
  }

  static Uri getOrdersUri(String? token, String? userId) {
    checkTokenAndUserIdNotNull(token, userId);
    return Uri.https(appFirebaseUrl, "/orders/$userId.json", {'auth': token});
  }

  static void checkTokenAndUserIdNotNull(String? token, String? userId) {
    if (token == null || userId == null) throw Exception('No Token or UserId provided!');
  }

  static Uri get signupUri => Uri.https(restAuthBaseUrl, signupPath, {'key': firebaseApiKey});

  static Uri get signinUri => Uri.https(restAuthBaseUrl, signinPath, {'key': firebaseApiKey});
}
