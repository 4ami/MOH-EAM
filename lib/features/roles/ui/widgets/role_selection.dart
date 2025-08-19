import 'package:flutter/material.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';

class RoleSelection extends StatelessWidget {
  final String resource;
  final List<String> actions;
  final Set<String> permissions;
  final void Function(String action, bool isSelected) callback;

  const RoleSelection({
    super.key,
    required this.resource,
    required this.actions,
    required this.permissions,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    var t = context.translate;
    return Column(
      children: [
        const Divider(),
        Text(t(key: resource)),
        Wrap(
          children: List.generate(actions.length, (i) {
            return _checkBox(
              t(key: actions[i]),
              permissions.contains(actions[i]),
              (b) {
                callback(actions[i], b ?? false);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _checkBox(String action, bool value, void Function(bool?)? callback) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VerticalDivider(),
        Text(action),
        Checkbox.adaptive(value: value, onChanged: callback),
        const VerticalDivider(),
      ],
    );
  }
}
