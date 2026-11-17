import 'package:material_ui/material_ui.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _linkController = TextEditingController();

  static const _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  String _category = _categories.first;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a $fieldName.';
    }
    return null;
  }

  String? _validateOptionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final uri = Uri.tryParse(value.trim());
    final hasValidScheme = uri?.scheme == 'http' || uri?.scheme == 'https';
    if (uri == null || !hasValidScheme || uri.host.isEmpty) {
      return 'Enter a valid URL starting with http:// or https://.';
    }
    return null;
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Project added successfully!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Project Name: ${_nameController.text.trim()}'),
                Text('Description: ${_descriptionController.text.trim()}'),
                Text('Category: $_category'),
                Text(
                  'Technologies: ${_technologiesController.text.trim().isEmpty ? "Not provided" : _technologiesController.text.trim()}',
                ),
                Text(
                  'Link: ${_linkController.text.trim().isEmpty ? "Not provided" : _linkController.text.trim()}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    _formKey.currentState!.reset();
    _nameController.clear();
    _descriptionController.clear();
    _technologiesController.clear();
    _linkController.clear();
    setState(() => _category = _categories.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Project Form',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
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
                  Text(
                    'Add a portfolio project',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete the required information below. Your project will be shown in a confirmation dialog.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(
                      label: 'Project Name',
                      hint: 'Enter the project name',
                      icon: Icons.folder_outlined,
                    ),
                    validator: (value) =>
                        _validateRequired(value, 'project name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: _fieldDecoration(
                      label: 'Project Description',
                      hint: 'Describe the project and your contribution',
                      icon: Icons.description_outlined,
                    ),
                    validator: (value) =>
                        _validateRequired(value, 'project description'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: _fieldDecoration(
                      label: 'Project Category',
                      hint: 'Choose a category',
                      icon: Icons.category_outlined,
                    ),
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _category = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _technologiesController,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(
                      label: 'Technologies Used',
                      hint: 'Example: Flutter, Django, Figma',
                      icon: Icons.code,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _linkController,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    decoration: _fieldDecoration(
                      label: 'Project Link',
                      hint: 'https://example.com',
                      icon: Icons.link,
                    ),
                    validator: _validateOptionalUrl,
                    onFieldSubmitted: (_) => _saveProject(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _saveProject,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Project'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
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
}
