import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/entity/feature/users/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';
import 'package:moh_eam/features/entity/feature/users/ui/widgets/users_widgets_module.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key, required this.userEntity});

  final UserEntity userEntity;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserEntityBloc, UserEntityState>(
      listener: _userListener,
      child: ResponsiveScaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EditUserForm(user: widget.userEntity),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _userListener(BuildContext context, UserEntityState state) {
    if (state.event is UserEntitySuccessEvent) {
      if (state.event is FetchUserSuccessEvent) return;
      var t = context.translate;
      var success = state.event as UserEntitySuccessEvent;
      String title = t(key: success.title);
      String description = t(key: success.message);
      context.successToast(title: title, description: description);
      context.pop();
      context.goNamed(AppRoutesInformation.userManagement.name);
      return;
    }

    if (state.event is UserEntityFailedEvent) {
      var t = context.translate;
      var failed = state.event as UserEntityFailedEvent;
      String title = t(key: failed.title);
      String description = t(
        key: failed.message,
      ).replaceAll('\$reason', t(key: failed.reason));
      context.errorToast(title: title, description: description);
      context.pop();
      return;
    }
  }
}
