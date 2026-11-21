import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _responsibilitiesController = TextEditingController();

  static const _categories = [
    'Internship',
    'Part-time',
    'Program',
    'Volunteer',
    'Organization',
  ];

  String _category = _categories.first;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isOngoing = false;

  @override
  void dispose() {
    _titleController.dispose();
    _organizationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    _responsibilitiesController.dispose();
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) return;
    setState(() {
      _startDate = selectedDate;
      _startDateController.text = _formatDate(selectedDate);
    });
  }

  Future<void> _selectEndDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) return;
    setState(() {
      _endDate = selectedDate;
      _endDateController.text = _formatDate(selectedDate);
    });
  }

  String? _validateStartDate(String? value) {
    if (_startDate == null) return 'Choose a start date.';
    return null;
  }

  String? _validateEndDate(String? value) {
    if (_isOngoing) return null;
    if (_endDate == null) return 'Choose an end date.';
    if (_startDate != null && _endDate!.isBefore(_startDate!)) {
      return 'End date cannot be earlier than start date.';
    }
    return null;
  }

  void _setOngoing(bool value) {
    setState(() {
      _isOngoing = value;
      if (value) {
        _endDate = null;
        _endDateController.clear();
      }
    });
  }

  Future<void> _saveExperience() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Experience added successfully!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Title: ${_titleController.text.trim()}'),
                Text('Organization: ${_organizationController.text.trim()}'),
                Text('Category: $_category'),
                Text('Start Date: ${_startDateController.text}'),
                Text(
                  'End Date: ${_isOngoing ? "Ongoing" : _endDateController.text}',
                ),
                Text('Description: ${_descriptionController.text.trim()}'),
                Text(
                  'Responsibilities: ${_responsibilitiesController.text.trim()}',
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
    _titleController.clear();
    _organizationController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _descriptionController.clear();
    _responsibilitiesController.clear();
    setState(() {
      _category = _categories.first;
      _startDate = null;
      _endDate = null;
      _isOngoing = false;
    });
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Experience Form',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
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
                  Text(
                    'Add a portfolio experience',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share a role or program that helped shape your skills.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: const Key('experience-title'),
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(
                      label: 'Experience Title',
                      hint: 'Example: Product Management Intern',
                      icon: Icons.work_outline,
                    ),
                    validator: (value) => FormValidators.requiredText(
                      value,
                      'experience title',
                      minLength: 3,
                      maxLength: 100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('experience-organization'),
                    controller: _organizationController,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(
                      label: 'Organization',
                      hint: 'Enter the organization name',
                      icon: Icons.business_outlined,
                    ),
                    validator: (value) => FormValidators.requiredText(
                      value,
                      'organization',
                      minLength: 2,
                      maxLength: 100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: const Key('experience-category'),
                    initialValue: _categories.first,
                    decoration: _fieldDecoration(
                      label: 'Experience Category',
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
                  DateFormField(
                    fieldKey: const Key('experience-start-date'),
                    controller: _startDateController,
                    label: 'Start Date',
                    hint: 'Choose the start date',
                    onTap: _selectStartDate,
                    validator: _validateStartDate,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    key: const Key('experience-ongoing'),
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ongoing Experience'),
                    subtitle: const Text(
                      'Turn this on if the experience has not ended.',
                    ),
                    value: _isOngoing,
                    onChanged: _setOngoing,
                  ),
                  const SizedBox(height: 12),
                  DateFormField(
                    fieldKey: const Key('experience-end-date'),
                    controller: _endDateController,
                    label: 'End Date',
                    hint: _isOngoing ? 'Ongoing' : 'Choose the end date',
                    onTap: _selectEndDate,
                    validator: _validateEndDate,
                    enabled: !_isOngoing,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('experience-description'),
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: _fieldDecoration(
                      label: 'Description',
                      hint: 'Describe the role and what you learned',
                      icon: Icons.description_outlined,
                    ),
                    validator: (value) => FormValidators.requiredText(
                      value,
                      'description',
                      minLength: 10,
                      maxLength: 500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('experience-responsibilities'),
                    controller: _responsibilitiesController,
                    maxLines: 5,
                    decoration: _fieldDecoration(
                      label: 'Responsibilities',
                      hint: 'Explain your main contributions',
                      icon: Icons.task_alt_outlined,
                    ),
                    validator: (value) => FormValidators.requiredText(
                      value,
                      'responsibility summary',
                      minLength: 10,
                      maxLength: 500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      key: const Key('save-experience'),
                      onPressed: _saveExperience,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Experience'),
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
