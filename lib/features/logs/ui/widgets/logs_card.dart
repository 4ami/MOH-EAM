part of 'logs_widgets_module.dart';

class LogsCard extends StatelessWidget {
  final LogEntity log;

  const LogsCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _boxDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t(key: 'movement_card_title'),
              style: context.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            _sub(context),
          ],
        ),
      ),
    );
  }

  Widget _sub(BuildContext context) {
    final t = context.translate;
    final props = {
      "movement_state": log.state,
      "action_by": log.actionBy ?? '-',
      "target_user": log.targetUser ?? '-',
      "note": log.note ?? '-',
      "logged_at": log.loggedAtFormatted,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: props.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              '${t(key: key)}:',
              style: context.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                decoration: (value.isEmpty) ? TextDecoration.lineThrough : null,
              ),
              textScaler: const TextScaler.linear(.8),
            ),
            Expanded(child: _buildVal(key, value, context)),
          ],
        );
      }).toList(),
    );
  }

  SelectableText _buildVal(String key, dynamic value, BuildContext context) {
    if (value == null || (value is String && value.isEmpty)) {
      return const SelectableText('-', textScaler: TextScaler.linear(.8));
    }

    if (key == 'movement_state') {
      return SelectableText(
        context.translate(key: value.toString().toLowerCase()),
        style: context.bodyLarge!.copyWith(
          color: _stateColor(value),
          fontWeight: FontWeight.bold,
        ),
        textScaler: const TextScaler.linear(.8),
      );
    }

    return SelectableText(
      value.toString(),
      textScaler: const TextScaler.linear(.8),
      textDirection: key == "logged_at" ? TextDirection.ltr : null,
    );
  }

  Color _stateColor(String value) {
    final states = {
      'STORED': Colors.amber,
      'RETURNED': Colors.redAccent,
      'ASSIGNED': Colors.lightGreen,
      'UNASSIGNED': Colors.deepOrange,
    };
    return states[value] ?? Colors.blueGrey;
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [context.surface, context.surfaceDim],
      ),
      boxShadow: [
        BoxShadow(
          color: context.shadow.withAlpha(50),
          blurRadius: 10,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ],
    );
  }
}
