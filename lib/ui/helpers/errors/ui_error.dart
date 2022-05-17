enum UIError { unexpected }

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      default:
        return "Algo errado aconteceu. Tente novamente em breve.";
    }
  }
}
