import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Represents one project returned by the Django portfolio API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.title,
    this.slug = '',
    required this.summary,
    required this.context,
    required this.role,
    required this.contributions,
    required this.technologies,
    required this.projectUrl,
    required this.imagePath,
    required this.startedOn,
    this.endedOn,
    this.achievement = '',
    this.isFeatured = false,
    this.createdAt,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String slug;
  final String summary;
  final String context;
  final String role;
  final List<String> contributions;
  final List<String> technologies;
  final String projectUrl;
  final String imagePath;
  final String startedOn;
  final String? endedOn;
  final String achievement;
  final bool isFeatured;

  @JsonKey(includeToJson: false)
  final String? createdAt;

  @JsonKey(includeToJson: false)
  final int starCount;

  @JsonKey(includeToJson: false)
  final bool isStarred;

  @JsonKey(includeToJson: false)
  final String starredByNames;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$ProjectToJson(this);
    if (slug.isEmpty) json.remove('slug');
    return json;
  }
}
