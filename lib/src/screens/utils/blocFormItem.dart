
// We validate all the errors that the user can type in the text fields
// Well loaded email validation
// Password validation with minimum number of characters
class BlocFormItem {
  
  final String value;
  final String? error;

  const BlocFormItem({
    this.value = '',
    this.error
  });

  BlocFormItem copyWith({
    String? value,
    String? error
  }) {
    return BlocFormItem(
      // Set the data that the user uploads. In case of null, I assign the default value
      value: value ?? this.value,
      error: error ?? this.error
    );
  }

}