part of '../admin_widgets_module.dart';

class AdminSearchBar extends StatelessWidget {
  const AdminSearchBar({super.key, this.controller});
  final TextEditingController? controller;

  Widget _innerContainer(BuildContext context) => BackdropFilter(
    filter: ImageFilter.blur(),
    child: Container(
      decoration: _inner(context),
      //search field
      child: _field(context),
    ),
  );

  Widget _field(BuildContext context) {
    var t = context.translate;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return t(key: 'field_required');
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: context.translate(key: 'search_bar_label'),
          hintText: context.translate(key: 'search_bar_hint'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: context.responsive.scale(250, .8),
      decoration: _decoration(context),
      child: _innerContainer(context),
    );
  }

  BoxDecoration _inner(BuildContext context) {
    return BoxDecoration(
      color: context.surface.withValues(alpha: .5),
      borderRadius: BorderRadius.circular(context.responsive.borderRadius),
      boxShadow: [
        BoxShadow(
          blurRadius: 15,
          offset: -const Offset(0, 0),
          color: context.surface.withValues(alpha: .5),
          spreadRadius: 4,
          blurStyle: BlurStyle.solid,
        ),
        BoxShadow(
          blurRadius: 15,
          offset: const Offset(0, 0),
          color: context.inverseSurface.withValues(alpha: .06),
          spreadRadius: 4,
          blurStyle: BlurStyle.solid,
        ),
      ],
    );
  }

  BoxDecoration _decoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(context.responsive.borderRadius),
      boxShadow: [
        BoxShadow(
          blurRadius: 32,
          offset: const Offset(10, 10),
          color: context.shadow.withValues(alpha: .15),
          blurStyle: BlurStyle.normal,
          // spreadRadius: 2,
        ),
        BoxShadow(
          blurRadius: 32,
          offset: -const Offset(15, 15),
          color: context.surfaceBright.withValues(alpha: .06),
          blurStyle: BlurStyle.normal,
          // spreadRadius: 2,
        ),
      ],
    );
  }
}
