/// Data model for build-time information captured from Git and pubspec.
class BuildInfo {
  /// The Git commit hash at the time of build.
  final String? commitHash;

  /// The Git branch name at the time of build.
  final String? branch;

  /// The author of the last Git commit.
  final String? author;

  /// The timestamp when the build info was generated.
  final String? buildDate;

  /// A map of project dependencies and their versions.
  final Map<String, dynamic>? dependencies;

  /// A map of project dev_dependencies and their versions.
  final Map<String, dynamic>? devDependencies;

  BuildInfo({
    this.commitHash,
    this.branch,
    this.author,
    this.buildDate,
    this.dependencies,
    this.devDependencies,
  });

  factory BuildInfo.fromJson(Map<String, dynamic> json) {
    return BuildInfo(
      commitHash: json['commitHash'],
      branch: json['branch'],
      author: json['author'],
      buildDate: json['buildDate'],
      dependencies: json['dependencies'] != null
          ? Map<String, dynamic>.from(json['dependencies'])
          : null,
      devDependencies: json['devDependencies'] != null
          ? Map<String, dynamic>.from(json['devDependencies'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (commitHash != null) 'commitHash': commitHash,
      if (branch != null) 'branch': branch,
      if (author != null) 'author': author,
      if (buildDate != null) 'buildDate': buildDate,
      if (dependencies != null) 'dependencies': dependencies,
      if (devDependencies != null) 'devDependencies': devDependencies,
    };
  }
}
