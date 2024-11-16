// Function that allows converting an Array into String
// Used when an Error Status comes with Message Array
String listToString(dynamic data) {
  String message = '';
  if (data is List<dynamic>) {
    // message = (data as List<dynamic>).join(" ");
    message = data.join(" ");
  }
  else if (data is String) {
    message = data;
  }
  return message;
}