// Handler of state changes in the response
// Class that allows us to capture the data or error of a request
abstract class Resource<T> {}

// Loading state
class Loading extends Resource {}

// Catch successful information
class Success<T> extends Resource<T> {
  final T data;
  Success(this.data);
}

// Catch errors
class ErrorData<T> extends Resource<T> {
  final String message;
  ErrorData(this.message);
}