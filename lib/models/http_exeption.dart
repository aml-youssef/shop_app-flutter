class HttpExeption implements Exception {
  final String messege;

  HttpExeption(this.messege);

  String toString() {
    return messege;
  }
}
