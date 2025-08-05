part of 'widget_module.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: context.onPrimaryContainer),
        borderRadius: BorderRadius.circular(context.responsive.borderRadius),
      ),
      child: Transform.scale(
        scale: context.responsive.scale(.80, .8),
        child: DropdownButton<Locale>(
          alignment: Alignment.bottomCenter,
          value: context.watch<LanguageCubit>().state,
          borderRadius: BorderRadius.circular(context.responsive.borderRadius),
          underline: const Offstage(),
          hint: Text(context.translate(key: 'language_switch_title')),
          icon: Icon(Icons.language_rounded),
          items: [
            _buildItem(context, code: 'ar', titleKey: 'language_switch_ar'),
            _buildItem(context, code: 'en', titleKey: 'language_switch_en'),
          ],
          onChanged: (locale) {
            if (locale == null) return;
            context.read<LanguageCubit>().switchTo(locale);
          },
        ),
      ),
    );
  }

  DropdownMenuItem<Locale> _buildItem(
    BuildContext context, {
    required String code,
    required String titleKey,
  }) {
    DropdownMenuItem<Locale> item = DropdownMenuItem<Locale>(
      value: Locale(code),
      child: Text(context.translate(key: titleKey)),
    );
    return item;
  }
}
