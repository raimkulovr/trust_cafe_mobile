abstract class PathConstants {
  static String get scrollToSlugKey => 'scrollToSlug';
  static String get tabContainerPath => '/';
  static String get authPath => '${tabContainerPath}auth';
  static String get feedPath => '${tabContainerPath}feed';
  static String get settingsPath => '${tabContainerPath}settings';
  static String get advancedPath => '${tabContainerPath}advanced';

  static String postDetailsPath({
    required String postId,
  }) => '${tabContainerPath}post/$postId';
}
