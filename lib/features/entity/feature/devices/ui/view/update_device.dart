import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/entity/feature/devices/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/patch_device.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';
import 'package:moh_eam/features/entity/feature/users/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';

class UpdateDeviceWidget extends StatefulWidget {
  const UpdateDeviceWidget({super.key, required this.device});
  final DeviceEntity device;
  @override
  State<UpdateDeviceWidget> createState() => _UpdateDeviceWidgetState();
}

class _UpdateDeviceWidgetState extends State<UpdateDeviceWidget> {
  final _formKey = GlobalKey<FormState>();
  final _checkKey = GlobalKey<FormState>();
  final _serial = TextEditingController();
  final _model = TextEditingController();
  final _type = TextEditingController();
  final _hostName = TextEditingController();
  final _username = TextEditingController();
  UserEntity? _user;

  final Map<String, bool> _boolValues = {
    'in_domain': false,
    'kasper_installed': false,
    'crowdstrike_installed': false,
  };

  //field builder
  Widget _fieldBuilder({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    required void Function(String) onChanged,
    TextInputType? type,
    int? minLines,
    int? maxLines,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: type,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          label: required ? _requiredField(label) : null,
          labelText: required ? null : label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

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

  Widget? _showUserInfo(UserEntity? u) {
    if (u == null) return null;
    var t = context.translate;
    return ExpansionTile(
      title: Text(t(key: 'user_information')),
      children: [
        Row(
          children: [
            Text('${t(key: 'username')}:'),
            Expanded(child: SelectableText(u.username)),
          ],
        ),
        Row(
          children: [
            Text('${t(key: 'full_name_ar')}:'),
            Expanded(child: SelectableText(u.fullNameAR ?? '-')),
          ],
        ),
        Row(
          children: [
            Text('${t(key: 'full_name_en')}:'),
            Expanded(child: SelectableText(u.fullNameEN ?? '-')),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _serial.text = widget.device.serial;
    _model.text = widget.device.model;
    _type.text = widget.device.type;
    _hostName.text = widget.device.hostName ?? '';
    _serial.text = widget.device.serial;
    _username.text = widget.device.user?.username ?? '';

    _boolValues['in_domain'] = widget.device.inDomain ?? false;
    _boolValues['kasper_installed'] = widget.device.kasperInstalled ?? false;
    _boolValues['crowdstrike_installed'] =
        widget.device.crowdStrikeInstalled ?? false;

    context.read<UserEntityBloc>().add(
      UserEntitySearchFiltersChanged(
        page: UpdateTo(1),
        limit: UpdateTo(1),
        query: UpdateTo(_username.text),
      ),
    );

    _user = widget.device.user;
  }

  @override
  Widget build(BuildContext context) {
    var t = context.translate;

    var uw = context.watch<UserEntityBloc>();
    var ur = context.read<UserEntityBloc>();

    ur.add(
      UserEntitySearchFiltersChanged(page: UpdateTo(1), limit: UpdateTo(1)),
    );

    var w = context.watch<DeviceBloc>();

    final serialField = _fieldBuilder(
      required: true,
      controller: _serial,
      label: t(key: 'serial'),
      onChanged: (s) {},
      validator: (s) => ValidationHelper.serial(s, context),
    );

    final modelField = _fieldBuilder(
      required: true,
      controller: _model,
      label: t(key: 'model'),
      onChanged: (m) {},
      validator: (m) => ValidationHelper.model(m, context),
    );

    final typeField = _fieldBuilder(
      required: true,
      controller: _type,
      label: t(key: 'type'),
      onChanged: (t) {},
      validator: (t) => ValidationHelper.type(t, context),
    );

    final hostNameField = _fieldBuilder(
      controller: _hostName,
      label: t(key: 'host_name'),
      onChanged: (hn) {},
      validator: (hn) => ValidationHelper.hostName(hn, context),
    );

    final boolSwitch = _boolValues.entries.map((e) {
      return SwitchListTile.adaptive(
        title: Text(t(key: 'is_${e.key}?')),
        value: _boolValues[e.key]!,
        onChanged: (b) {
          setState(() {
            _boolValues[e.key] = b;
          });
        },
      );
    }).toList();

    final assignUser = BlocListener<UserEntityBloc, UserEntityState>(
      listener: (context, state) {
        if (state.event is UserEntitySuccessEvent) {
          if (state.users.length == 1) {
            setState(() => _user = state.users[0]);
            return;
          }
        }
      },
      child: _assignBuilder(t, ur, uw),
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.only(
          left: context.responsive.padding,
          right: context.responsive.padding,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 25,
          top: MediaQuery.viewInsetsOf(context).top + 25,
        ),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(context.responsive.borderRadius),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 15,
              children: [
                Text(
                  context.translate(key: 'update_device_title'),
                  style: context.h4,
                ),
                serialField,
                modelField,
                typeField,
                hostNameField,
                ...boolSwitch,
                assignUser,
                ElevatedButton.icon(
                  onPressed: w.state.event is DeviceLoadingEvent
                      ? null
                      : _submit,
                  label: Text(context.translate(key: 'update_device_btn')),
                  icon: w.state.event is DeviceLoadingEvent
                      ? SizedBox(
                          width: 30,
                          height: 30,
                          child: const CircularProgressIndicator(),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _assignBuilder(
    String Function({String fallback, required String key, bool useFallback}) t,
    UserEntityBloc ur,
    UserEntityBloc uw,
  ) {
    return Form(
      key: _checkKey,
      child: Column(
        spacing: 15,
        children: [
          const Divider(),
          Text(t(key: 'assign_user')),
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 350),
                    child: TextFormField(
                      controller: _username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t(key: 'field_required');
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: t(key: 'assign_to_user_hint'),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        ur.add(
                          UserEntitySearchFiltersChanged(
                            query: UpdateTo(value),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: uw.state.event is UserEntityLoadingEvent
                    ? null
                    : () => _search(ur),
                child: Text(t(key: 'check')),
              ),

              if (uw.state.event is UserEntitySuccessEvent &&
                  ur.state.users.isNotEmpty)
                Text('✅'),
              if (uw.state.event is UserEntityFailedEvent ||
                  ur.state.users.isEmpty)
                Text('❌'),
            ],
          ),
          if (uw.state.event is UserEntitySuccessEvent)
            ?_showUserInfo(
              ur.state.users.isNotEmpty ? ur.state.users[0] : null,
            ),
        ],
      ),
    );
  }

  void _search(UserEntityBloc ur) {
    if (_checkKey.currentState?.validate() == true) {
      var a = context.read<AuthBloc>().state as AuthenticatedState;
      ur.add(UserEntityFetchUsersEvent(token: a.token));
    }
  }

  @override
  void dispose() {
    _serial.dispose();
    _model.dispose();
    _type.dispose();
    _hostName.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() == true) {
      DeviceEntity device = DeviceEntity(
        id: widget.device.id,
        serial: _serial.text.trim(),
        model: _model.text.trim(),
        type: _type.text.trim(),
        hostName: _hostName.text.isEmpty ? null : _hostName.text.trim(),
        inDomain: _boolValues['in_domain'],
        kasperInstalled: _boolValues['kasper_installed'],
        crowdStrikeInstalled: _boolValues['crowdstrike_installed'],
        user: _user,
      );

      PatchDeviceRequest deviceRequest = PatchDeviceRequest(device: device);

      var a = context.read<AuthBloc>().state as AuthenticatedState;

      DeviceEvents event = PatchDeviceEvent(
        token: a.token,
        deviceRequest: deviceRequest,
      );

      context.read<DeviceBloc>().add(event);
    }
  }
}
