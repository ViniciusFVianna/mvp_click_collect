import 'package:flutter/widgets.dart';

class Command<T> extends ChangeNotifier {
  T data;
  bool isLoading;
  String? error;

  Command({required this.data, this.isLoading = false, this.error});

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setData(T newData) {
    data = newData;
    error = null;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    error = errorMessage;
    isLoading = false;
    notifyListeners();
  }

  void execute() => notifyListeners();
}
