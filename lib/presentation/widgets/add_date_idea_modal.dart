import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/date_idea_model.dart';
import '../../data/services/date_idea_service.dart';
import '../../core/theme/app_theme.dart';

class AddDateIdeaModal extends ConsumerStatefulWidget {
  final DateIdeaModel? ideaToEdit;

  const AddDateIdeaModal({super.key, this.ideaToEdit});

  @override
  ConsumerState<AddDateIdeaModal> createState() => _AddDateIdeaModalState();
}

class _AddDateIdeaModalState extends ConsumerState<AddDateIdeaModal> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedDateType;
  String? _selectedBudget;

  final List<String> _dateTypes = [
    'Cozy',
    'Outdoor',
    'Fancy',
    'Adventurous',
    'Lazy Day'
  ];

  final List<String> _budgetRanges = ['₹', '₹₹', '₹₹₹'];

  @override
  void initState() {
    super.initState();
    if (widget.ideaToEdit != null) {
      _titleController.text = widget.ideaToEdit!.title;
      _notesController.text = widget.ideaToEdit!.notes;
      _selectedDateType = widget.ideaToEdit!.dateType;
      _selectedBudget = widget.ideaToEdit!.budgetRange;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _titleController.text.trim().isNotEmpty &&
      _notesController.text.trim().isNotEmpty &&
      _selectedDateType != null &&
      _selectedBudget != null;

  void _saveIdea() async {
    if (!_isValid) return;

    final newIdea = DateIdeaModel(
      id: widget.ideaToEdit?.id ?? '',
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      dateType: _selectedDateType!,
      budgetRange: _selectedBudget!,
      createdAt: widget.ideaToEdit?.createdAt ?? DateTime.now(),
    );

    if (widget.ideaToEdit == null) {
      await ref.read(dateIdeaServiceProvider).addDateIdea(newIdea);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("New date idea saved ❤️"),
            backgroundColor: AppTheme.primaryColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      await ref.read(dateIdeaServiceProvider).updateDateIdea(newIdea);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.ideaToEdit == null ? "Add Date Idea ✨" : "Edit Date Idea ✏️",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 24,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Notes / Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text(
              "Date Type",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dateTypes.map((type) {
                final isSelected = _selectedDateType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                  backgroundColor: AppTheme.surfaceColor,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedDateType = selected ? type : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              "Budget Range",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _budgetRanges.map((budget) {
                final isSelected = _selectedBudget == budget;
                return ChoiceChip(
                  label: Text(budget),
                  selected: isSelected,
                  selectedColor: Colors.green.withOpacity(0.2),
                  backgroundColor: AppTheme.surfaceColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.green : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedBudget = selected ? budget : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isValid ? _saveIdea : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Save Idea ✨",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
