/// Safely reads an int that may arrive as int, String, or null. ----
int? parseInt(dynamic value) {
  if (value == null) return null;
  return int.tryParse(value.toString());
}

/// Safely reads a String, never null.
String parseString(dynamic value) => value?.toString() ?? '';


//this is basically helper for null safety ;;;;