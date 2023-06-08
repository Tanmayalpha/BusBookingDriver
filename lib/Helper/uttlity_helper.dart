class UttlityHelper {
  static String convertNA(data) {
    if (data == null) {
      return "";
    } else {
      return data ?? "";
    }
  }
}
