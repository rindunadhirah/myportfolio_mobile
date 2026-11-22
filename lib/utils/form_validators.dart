/// Reusable validation rules shared by portfolio forms.
abstract final class FormValidators {
  static String? requiredText(
    String? value,
    String fieldName, {
    int? minLength,
    int? maxLength,
  }) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      final firstLetter = fieldName.trim().toLowerCase()[0];
      final article = 'aeiou'.contains(firstLetter) ? 'an' : 'a';
      return 'Enter $article $fieldName.';
    }

    if (minLength != null && trimmedValue.length < minLength) {
      return '$fieldName must contain at least $minLength characters.';
    }
    if (maxLength != null && trimmedValue.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters.';
    }
    return null;
  }

  static String? optionalUrl(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) return null;

    final uri = Uri.tryParse(trimmedValue);
    final hasValidScheme = uri?.scheme == 'http' || uri?.scheme == 'https';
    if (uri == null || !hasValidScheme || uri.host.isEmpty) {
      return 'Enter a valid URL starting with http:// or https://.';
    }
    return null;
  }
}
