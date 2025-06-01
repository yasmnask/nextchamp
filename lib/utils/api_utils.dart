class ApiUtils {
  // Build query parameters for Strapi
  static Map<String, dynamic> buildStrapiQuery({
    List<String>? populate,
    Map<String, dynamic>? filters,
    Map<String, String>? sort,
    int? page,
    int? pageSize,
    String? locale,
  }) {
    final Map<String, dynamic> query = {};

    if (populate != null && populate.isNotEmpty) {
      query['populate'] = populate.join(',');
    }

    if (filters != null && filters.isNotEmpty) {
      filters.forEach((key, value) {
        query['filters[$key]'] = value;
      });
    }

    if (sort != null && sort.isNotEmpty) {
      final sortParams = sort.entries
          .map((e) => '${e.key}:${e.value}')
          .join(',');
      query['sort'] = sortParams;
    }

    if (page != null) {
      query['pagination[page]'] = page;
    }

    if (pageSize != null) {
      query['pagination[pageSize]'] = pageSize;
    }

    if (locale != null) {
      query['locale'] = locale;
    }

    return query;
  }

  // Extract error message from Dio exception
  static String extractErrorMessage(dynamic error) {
    if (error.response?.data != null) {
      final data = error.response.data;

      // Strapi v4 error format
      if (data['error'] != null) {
        return data['error']['message'] ?? 'Unknown error occurred';
      }

      // Strapi v3 error format
      if (data['message'] != null) {
        return data['message'];
      }

      // Validation errors
      if (data['details'] != null && data['details']['errors'] != null) {
        final errors = data['details']['errors'] as List;
        return errors.map((e) => e['message']).join(', ');
      }
    }

    return error.message ?? 'Network error occurred';
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate password strength
  static bool isStrongPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }
}
