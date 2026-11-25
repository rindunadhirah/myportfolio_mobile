import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';
import 'package:myportofolio_mobile/widgets/form_intro.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contextController = TextEditingController();
  final _roleController = TextEditingController();
  final _contributionsController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _projectUrlController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _achievementController = TextEditingController();

  DateTime? _startedOn;
  DateTime? _endedOn;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contextController.dispose();
    _roleController.dispose();
    _contributionsController.dispose();
    _technologiesController.dispose();
    _projectUrlController.dispose();
    _imageUrlController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _achievementController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startedOn ?? now)
          : (_endedOn ?? _startedOn ?? now),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null) return;

    setState(() {
      if (isStartDate) {
        _startedOn = selectedDate;
        _startDateController.text = _formatDate(selectedDate);
      } else {
        _endedOn = selectedDate;
        _endDateController.text = _formatDate(selectedDate);
      }
    });
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context) || !mounted) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final project = Project(
      title: _titleController.text.trim(),
      summary: _summaryController.text.trim(),
      context: _contextController.text.trim(),
      role: _roleController.text.trim(),
      contributions: _splitLines(_contributionsController.text),
      technologies: _splitCommaSeparated(_technologiesController.text),
      projectUrl: _projectUrlController.text.trim(),
      imagePath: _imageUrlController.text.trim(),
      startedOn: _startDateController.text,
      endedOn: _endDateController.text.isEmpty ? null : _endDateController.text,
      achievement: _achievementController.text.trim(),
    );

    try {
      final savedProject = await _createWithAuthentication(project);
      if (!mounted) return;
      await _showSuccessDialog(savedProject);
      if (mounted) _resetForm();
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<Project> _createWithAuthentication(Project project) async {
    final authState = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();

    try {
      return await apiClient.createProject(project, token: authState.token!);
    } on ApiException catch (error) {
      if (error.statusCode != 401) rethrow;

      try {
        await authState.logout();
      } on ApiException {
        // The local token is cleared even when server logout fails.
      }
      if (!mounted || !await ensureLoggedIn(context)) rethrow;

      return apiClient.createProject(project, token: authState.token!);
    }
  }

  Future<void> _showSuccessDialog(Project project) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Project added successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project: ${project.title}'),
            Text('Role: ${project.role}'),
            Text('Technologies: ${project.technologies.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    for (final controller in [
      _titleController,
      _summaryController,
      _contextController,
      _roleController,
      _contributionsController,
      _technologiesController,
      _projectUrlController,
      _imageUrlController,
      _startDateController,
      _endDateController,
      _achievementController,
    ]) {
      controller.clear();
    }
    setState(() {
      _startedOn = null;
      _endedOn = null;
    });
    _formKey.currentState!.reset();
  }

  String? _requiredUrl(String? value, String fieldName) {
    return FormValidators.requiredText(value, fieldName) ??
        FormValidators.optionalUrl(value);
  }

  String? _validateEndDate(String? value) {
    if (_startedOn != null &&
        _endedOn != null &&
        _endedOn!.isBefore(_startedOn!)) {
      return 'End date cannot be earlier than start date.';
    }
    return null;
  }

  List<String> _splitLines(String value) => value
      .split('\n')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> _splitCommaSeparated(String value) => value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a Project'), centerTitle: true),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormIntro(
                    title: 'Share a project',
                    description: 'Add the story behind your work and save it to your Django portfolio.',
                    icon: Icons.folder_outlined,
                  ),
                  const SizedBox(height: 24),
                  _textField(
                    key: const Key('project-title'),
                    controller: _titleController,
                    label: 'Project Title',
                    hint: 'Example: SisPro',
                    icon: Icons.folder_outlined,
                    validator: (value) => FormValidators.requiredText(
                      value,
                      'project title',
                      maxLength: 100,
                    ),
                  ),
                  _gap,
                  _textField(
                    key: const Key('project-summary'),
                    controller: _summaryController,
                    label: 'Summary',
                    hint: 'Explain the project briefly',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                    validator: (value) =>
                        FormValidators.requiredText(value, 'project summary'),
                  ),
                  _gap,
                  _textField(
                    key: const Key('project-context'),
                    controller: _contextController,
                    label: 'Project Context',
                    hint: 'Example: SISTECH final project',
                    icon: Icons.info_outline,
                    validator: (value) => FormValidators.requiredText(
                      value,
                      'project context',
                      maxLength: 255,
                    ),
                  ),
                  _gap,
                  _textField(
                    key: const Key('project-role'),
                    controller: _roleController,
                    label: 'Your Role',
                    hint: 'Example: Product Manager',
                    icon: Icons.person_outline,
                    validator: (value) => FormValidators.requiredText(
                      value,
                      'project role',
                      maxLength: 100,
                    ),
                  ),
                  _gap,
                  _textField(
                    key: const Key('project-contributions'),
                    controller: _contributionsController,
                    label: 'Contributions',
                    hint: 'Write one contribution per line',
                    icon: Icons.checklist,
                    maxLines: 4,
                    validator: (value) =>
                        FormValidators.requiredText(value, 'contribution'),
                  ),
                  _gap,
                  _textField(
                    key: const Key('project-technologies'),
                    controller: _technologiesController,
                    label: 'Technologies',
                    hint: 'Example: Flutter, Django, Figma',
                    icon: Icons.code,
                    validator: (value) =>
                        FormValidators.requiredText(value, 'technology'),
                  ),
                  _gap,
                  _textField(
                    key: const Key('project-url'),
                    controller: _projectUrlController,
                    label: 'Project URL',
                    hint: 'https://example.com',
                    icon: Icons.link,
                    keyboardType: TextInputType.url,
                    validator: (value) => _requiredUrl(value, 'project URL'),
                  ),
                  _gap,
                  _textField(
                    key: const Key('project-image-url'),
                    controller: _imageUrlController,
                    label: 'Project Image URL (Optional)',
                    hint: 'https://example.com/preview.png',
                    icon: Icons.image_outlined,
                    keyboardType: TextInputType.url,
                    validator: FormValidators.optionalUrl,
                  ),
                  _gap,
                  DateFormField(
                    fieldKey: const Key('project-start-date'),
                    controller: _startDateController,
                    label: 'Start Date',
                    hint: 'Choose the project start date',
                    onTap: () => _pickDate(isStartDate: true),
                    validator: (value) =>
                        FormValidators.requiredText(value, 'start date'),
                  ),
                  _gap,
                  DateFormField(
                    fieldKey: const Key('project-end-date'),
                    controller: _endDateController,
                    label: 'End Date (Optional)',
                    hint: 'Leave empty if the project is ongoing',
                    onTap: () => _pickDate(isStartDate: false),
                    validator: _validateEndDate,
                  ),
                  _gap,
                  _textField(
                    key: const Key('project-achievement'),
                    controller: _achievementController,
                    label: 'Achievement (Optional)',
                    hint: 'Example: Best Final Project',
                    icon: Icons.emoji_events_outlined,
                    validator: (value) {
                      if ((value?.trim().length ?? 0) > 255) {
                        return 'Achievement must not exceed 255 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      key: const Key('project-submit'),
                      onPressed: _isSubmitting ? null : _saveProject,
                      icon: _isSubmitting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.cloud_upload_outlined),
                      label: Text(
                        _isSubmitting ? 'Saving Project...' : 'Save Project',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 16);

  Widget _textField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
