part of '../page.dart';

class _SigninForm extends StatefulWidget {
  const _SigninForm({super.key});

  @override
  State<_SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<_SigninForm> {
  void _submit() {
    if (formKey.currentState?.validate() == true) {
      if (mounted) {
        var auth = context.read<AuthBloc>();
        var lang = context.read<LanguageCubit>();
        auth.add(AuthenticateEvent(locale: lang.state.languageCode));
      }
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var w = context.watch<AuthBloc>().state;
    var callBack = w.event is AuthPendingEvent ? null : _submit;
    return GlassContainer(
      width: context.responsive.scale(500, .8),
      height: context.responsive.height(.8),
      child: Form(
        key: formKey,
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textAlign: TextAlign.center,
              context.translate(key: 'signin_title'),
              style: context.h1!.copyWith(
                fontSize: context.responsive.scale(35, .9),
              ),
            ),
            buildField(
              context.translate(key: 'signin_username_label'),
              'user1234',
              validator: (u) => ValidationHelper.username(u, context),
              onChanged: (p0) {
                context.read<AuthBloc>().add(
                  UsernameChanged(username: p0 ?? ''),
                );
              },
            ),
            buildField(
              context.translate(key: 'signin_password_label'),
              '********',
              hideContent: true,
              onChanged: (p0) {
                context.read<AuthBloc>().add(
                  PasswordChanged(password: p0 ?? ''),
                );
              },
              validator: (p) => ValidationHelper.password(p, context),
            ),
            if (w.event is AuthenticationFailed)
              Text(
                context.translate(
                  key: w.event.message,
                  fallback: 'general_error_message',
                  useFallback: true,
                ),
                style: context.bodyLarge!.copyWith(color: context.error),
              ),
            Transform.scale(
              scale: context.responsive.scale(.8, .8),
              child: SizedBox(
                width: context.responsive.width(.5),
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: callBack,
                  label: Text(context.translate(key: 'signin_button_title')),
                  icon: Icon(Icons.send_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildField(
    String label,
    String hint, {
    bool hideContent = false,
    TextDirection direction = TextDirection.ltr,
    String? Function(String?)? validator,
    void Function(String?)? onChanged,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      textDirection: direction,
      autovalidateMode: AutovalidateMode.onUnfocus,
      obscureText: hideContent,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hint: Text(hint),
        hintTextDirection: direction,
        labelText: label,
      ),
    );
  }
}
