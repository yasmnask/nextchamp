import 'strapi_query_builder.dart';

class StrapiQueryHelper {
  // Helper for building course queries
  static String buildCourseQuery({
    String? searchTerm,
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
    int? categoryId,
    bool? isFree,
    bool includeIcon = true,
    bool includeCategory = true,
  }) {
    final queryBuilder = StrapiQueryBuilder();

    // Add search if provided
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryBuilder.orContains('title', searchTerm);
      // Also search in description for more comprehensive results
      queryBuilder.orContains('description', searchTerm);
    }

    // Add category filter
    if (categoryId != null) {
      queryBuilder.filter('category.id', categoryId);
    }

    // Add free/premium filter
    if (isFree != null) {
      queryBuilder.filter('is_free', isFree);
    }

    // Add sorting
    if (sortField != null) {
      queryBuilder.sortBy(sortField, desc: sortDesc);
    } else {
      queryBuilder.sortBy('createdAt', desc: true); // Default sort by newest
    }

    // Add pagination if provided
    if (page != null && pageSize != null) {
      queryBuilder.paginate(page, pageSize);
    }

    // Add fields to select
    queryBuilder.select([
      'title',
      'description',
      'is_free',
      'createdAt',
      'updatedAt',
    ]);

    // Fix: Properly populate icon with all necessary fields
    if (includeIcon) {
      queryBuilder.populateField(
        'icon',
        fields: ['url', 'alternativeText', 'name', 'width', 'height'],
      );
    }

    if (includeCategory) {
      queryBuilder.populateField('category', fields: ['name']);
    }

    return queryBuilder.build();
  }

  // Helper for building single course query with all related data
  static String buildSingleCourseQuery({
    bool includeIcon = true,
    bool includeCategory = true,
  }) {
    final queryBuilder = StrapiQueryBuilder();

    // Select all fields for single course
    queryBuilder.select([
      'title',
      'description',
      'is_free',
      'createdAt',
      'updatedAt',
    ]);

    // Fix: Properly populate icon with all necessary fields
    if (includeIcon) {
      queryBuilder.populateField(
        'icon',
        fields: ['url', 'alternativeText', 'name', 'width', 'height'],
      );
    }

    if (includeCategory) {
      queryBuilder.populateField('category', fields: ['name']);
    }

    return queryBuilder.build();
  }

  // Helper for building category-specific queries
  static String buildCategoryCoursesQuery(
    int categoryId, {
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
    bool? isFree,
  }) {
    return buildCourseQuery(
      categoryId: categoryId,
      sortField: sortField,
      sortDesc: sortDesc,
      page: page,
      pageSize: pageSize,
      isFree: isFree,
    );
  }

  // Helper for building search queries
  static String buildSearchQuery(
    String searchTerm, {
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
    int? categoryId,
    bool? isFree,
  }) {
    return buildCourseQuery(
      searchTerm: searchTerm,
      sortField: sortField,
      sortDesc: sortDesc,
      page: page,
      pageSize: pageSize,
      categoryId: categoryId,
      isFree: isFree,
    );
  }

  // Helper for building category queries
  static String buildCategoryQuery({
    String? searchTerm,
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
    bool includeCourses = false,
  }) {
    final queryBuilder = StrapiQueryBuilder();

    // Add search if provided
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryBuilder.filterContains('name', searchTerm);
    }

    // Add sorting
    if (sortField != null) {
      queryBuilder.sortBy(sortField, desc: sortDesc);
    } else {
      queryBuilder.sortBy('name', desc: false); // Default sort by name
    }

    // Add pagination if provided
    if (page != null && pageSize != null) {
      queryBuilder.paginate(page, pageSize);
    }

    // Add fields to select
    queryBuilder.select(['name', 'createdAt', 'updatedAt']);

    if (includeCourses) {
      queryBuilder.populateField('courses', fields: ['id', 'title']);
    }

    return queryBuilder.build();
  }

  // Helper for building single category query
  static String buildSingleCategoryQuery({bool includeCourses = false}) {
    final queryBuilder = StrapiQueryBuilder();

    // Select all fields for single category
    queryBuilder.select(['name', 'createdAt', 'updatedAt']);

    if (includeCourses) {
      queryBuilder.populateField('courses', fields: ['id', 'title', 'is_free']);
    }

    return queryBuilder.build();
  }

  /// Helper for building mentor queries
  static String buildMentorQuery({
    String? searchTerm,
    String? sortField,
    bool sortDesc = false,
    int? page,
    int? pageSize,
    int? categoryId,
    bool? isFeatured,
    bool includeProfile = true,
    bool includeCategory = true,
  }) {
    final queryBuilder = StrapiQueryBuilder();

    // Add search if provided
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryBuilder.orContains('name', searchTerm);
      queryBuilder.orContains('description', searchTerm);
    }

    // Add category filter
    if (categoryId != null) {
      queryBuilder.filter('category.id', categoryId);
    }

    // Add featured filter
    if (isFeatured != null) {
      queryBuilder.filter('is_featured', isFeatured);
    }

    // Add sorting
    if (sortField != null) {
      queryBuilder.sortBy(sortField, desc: sortDesc);
    } else {
      queryBuilder.sortBy('createdAt', desc: true);
    }

    // Add pagination if provided
    if (page != null && pageSize != null) {
      queryBuilder.paginate(page, pageSize);
    }

    // Add fields to select
    queryBuilder.select([
      'name',
      'description',
      'is_featured',
      'createdAt',
      'updatedAt',
    ]);

    // Populate profile image
    if (includeProfile) {
      queryBuilder.populateField(
        'profile',
        fields: ['url', 'alternativeText', 'name', 'width', 'height'],
      );
    }

    // Populate category
    if (includeCategory) {
      queryBuilder.populateField('category', fields: ['name']);
    }

    return queryBuilder.build();
  }

  /// Helper for building single mentor query
  static String buildSingleMentorQuery({
    bool includeProfile = true,
    bool includeCategory = true,
  }) {
    final queryBuilder = StrapiQueryBuilder();

    // Select all fields for single mentor
    queryBuilder.select([
      'name',
      'description',
      'is_featured',
      'createdAt',
      'updatedAt',
    ]);

    // Populate profile image
    if (includeProfile) {
      queryBuilder.populateField(
        'profile',
        fields: ['url', 'alternativeText', 'name', 'width', 'height'],
      );
    }

    // Populate category
    if (includeCategory) {
      queryBuilder.populateField('category', fields: ['name']);
    }

    return queryBuilder.build();
  }

  /// Helper for building featured mentor queries
  static String buildFeaturedMentorQuery({
    String? sortField,
    bool sortDesc = false,
    int? pageSize,
  }) {
    return buildMentorQuery(
      isFeatured: true,
      sortField: sortField,
      sortDesc: sortDesc,
      pageSize: pageSize,
    );
  }
}
