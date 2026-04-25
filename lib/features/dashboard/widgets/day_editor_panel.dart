import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:work_track/core/extensions/string_extension.dart';
import '../../../core/worklog/worklog_model.dart';
import '../../../core/worklog/worklog_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../state/dashboard_providers.dart';

class DayEditorPanel extends ConsumerStatefulWidget {
  const DayEditorPanel({super.key});

  @override
  ConsumerState<DayEditorPanel> createState() => _DayEditorPanelState();
}

class _DayEditorPanelState extends ConsumerState<DayEditorPanel> {
  final _formKey = GlobalKey<FormState>();
  final _hoursController = TextEditingController();
  final _notesController = TextEditingController();
  final _hoursFocusNode = FocusNode();
  bool _isExtraDay = false;
  DateTime? _loadedFor;

  @override
  void dispose() {
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadLog(DateTime day, WorkLog? log) {
    _loadedFor = day;
    _hoursController.text = log != null ? log.hoursWorked.toString() : '';
    _notesController.text = log?.notes ?? '';
    _isExtraDay = log?.isExtraDay ?? false;
    _hoursFocusNode.requestFocus();
  }

  Future<void> _save(DateTime day) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final hours = double.tryParse(_hoursController.text) ?? 0;
    final log = WorkLog(
      date: day,
      hoursWorked: hours,
      isExtraDay: _isExtraDay,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    await ref.read(worklogRepositoryProvider).put(log);
  }

  Future<void> _clear(DateTime day) async {
    await ref.read(worklogRepositoryProvider).delete(day);
    _hoursController.clear();
    _notesController.clear();
    setState(() => _isExtraDay = false);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedDayProvider);

    if (selectedDay == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            AppLocalizations.of(context)!.selectADayLabel,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final month = DateTime(selectedDay.year, selectedDay.month);
    final logsAsync = ref.watch(worklogsForMonthProvider(month));
    final logs = logsAsync.value ?? [];
    final log = logs.cast<WorkLog?>().firstWhere(
      (l) => l?.key == WorkLog.keyFor(selectedDay),
      orElse: () => null,
    );

    // Seed form when selected day or log changes
    if (_loadedFor != selectedDay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _loadLog(selectedDay, log));
      });
    }

    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat.yMMMMEEEEd(
                  AppLocalizations.of(context)!.localeName,
                ).format(selectedDay).capitalize(),
                style: theme.textTheme.titleSmall!.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextFormField(
                  controller: _hoursController,
                  focusNode: _hoursFocusNode,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.hoursWorkedLabel,
                    suffixText: AppLocalizations.of(context)!.hoursAbbreviation,
                    hintText: AppLocalizations.of(context)!.hoursHintText,
                    border: InputBorder.none,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (v) {
                    if (v == null || v.isEmpty) return null; // empty = clear
                    final n = double.tryParse(v);
                    if (n == null || n < 0 || n > 24) {
                      return AppLocalizations.of(
                        context,
                      )!.hoursValidationMessage;
                    }
                    return null;
                  },
                  onChanged: (v) {
                    if (v.isNotEmpty) {
                      setState(() {});
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(AppLocalizations.of(context)!.extraDayLabel),
                subtitle: Text(AppLocalizations.of(context)!.extraDayHint),
                value: _isExtraDay,
                onChanged: (v) => setState(() => _isExtraDay = v),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.notesLabel,
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  if (log != null)
                    OutlinedButton(
                      onPressed: () => _clear(selectedDay),
                      child: Text(
                        AppLocalizations.of(context)!.clear,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _hoursController.text.isEmpty && log == null
                        ? null
                        : () => _save(selectedDay),
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
