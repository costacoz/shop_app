class HttpException implements Exception {
  final message;
  final uri;
  final statusCode;

  HttpException(this.message, {int? this.statusCode, Uri? this.uri});

  @override
  String toString() {
    var uriText = '';
    var statusCodeText = '';
    if (message == null) return "HttpException";
    if (statusCode != null) statusCodeText = " Status code: $statusCode.";
    if (uri != null) uriText = " Uri resource: $uri.";
    return "HttpException: $message.$statusCodeText$uriText";
  }
}
