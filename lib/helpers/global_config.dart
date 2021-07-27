class GlobalConfig {
  static const appFirebaseUrl = '***FIREBASE URL***';

  static const productsPath = "/products.json";

  static Uri getUriByProductId(String id) => Uri.https(appFirebaseUrl, '/products/$id.json');

  static Uri get productsUri => Uri.https(appFirebaseUrl, productsPath);
}
