part of 'device_widgets_module.dart';

class MovementStateDropDown extends StatefulWidget {
  const MovementStateDropDown({super.key, this.onChanged});
  final void Function(String)? onChanged;
  @override
  State<MovementStateDropDown> createState() => _MovementStateDropDownState();
}

class _MovementStateDropDownState extends State<MovementStateDropDown> {
  final values = ["STORED", "RETURNED", "ASSIGNED", "UNASSIGNED"];
  var selected = "UNASSIGNED";

  Widget _requiredField(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: context.labelLarge,
        children: [
          TextSpan(
            text: ' *',
            style: context.labelLarge!.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = context.translate;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: InputDecoration(
          label: widget.onChanged != null
              ? _requiredField(t(key: "movement_state_label"))
              : null,
          labelText: widget.onChanged != null
              ? null
              : t(key: "movement_state_label"),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            selected = value;
          });
          if (widget.onChanged != null) widget.onChanged!(selected);
        },
        items: values.map((v) {
          return DropdownMenuItem<String>(
            value: v,
            child: Text(t(key: v.toLowerCase())),
          );
        }).toList(),
      ),
    );
  }
}
