import 'package:flutter/widgets.dart';

class Command<T> extends ChangeNotifier {
  T data;
  bool isLoading;
  String? error;

  Command({required this.data, this.isLoading = false, this.error});

  void toggleLoading() {
    isLoading = !isLoading;
    execute();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    execute();
  }

  void setData(T newData) {
    data = newData;
    error = null;
    execute();
  }

  void setError(String? errorMessage) {
    error = errorMessage;
    isLoading = false;
    execute();
  }

  void execute() => notifyListeners();
}
