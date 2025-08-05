part of 'widget_module.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsive.padding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: context.responsive.scale(10, .2),
        children: [
          Icon(Icons.dark_mode_outlined, size: context.responsive.scale(20)),
          Transform.scale(
            scale: context.responsive.scale(.9, .8),
            child: Switch.adaptive(
              value: context.watch<ThemeCubit>().isLight,
              onChanged: (isLight) {
                context.read<ThemeCubit>().toggle();
              },
            ),
          ),
          Icon(Icons.light_mode_outlined, size: context.responsive.scale(20)),
        ],
      ),
    );
  }
}
