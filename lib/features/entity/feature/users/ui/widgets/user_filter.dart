part of 'users_widgets_module.dart';

class UserFilter extends StatefulWidget {
  const UserFilter({super.key});

  @override
  State<UserFilter> createState() => _UserFilterState();
}

class _UserFilterState extends State<UserFilter> {
  bool? hasDevices;
  String selectedDepartment = '';
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    var roles = context.read<GlobalDataBloc>().state.roles;
    var depts = context.read<GlobalDataBloc>().state.rootDepartments;
    var user = context.read<UserEntityBloc>();
    return Column(
      spacing: 15,
      children: [
        ExpansionTile(
          title: Text(context.translate(key: 'filter_by_devices_owned')),
          children: [
            FilterChip(
              label: Text(context.translate(key: 'has_devices_filter')),
              selected: hasDevices ?? false,
              onSelected: (b) {
                if (b) {
                  setState(() {
                    hasDevices = true;
                    user.add(
                      UserEntitySearchFiltersChanged(
                        hasDevice: UpdateTo(hasDevices),
                      ),
                    );
                  });
                } else {
                  setState(() {
                    hasDevices = null;
                    user.add(
                      UserEntitySearchFiltersChanged(
                        hasDevice: UpdateTo(hasDevices),
                      ),
                    );
                  });
                }
              },
            ),
            FilterChip(
              label: Text(context.translate(key: 'has_no_devices_filter')),
              selected: hasDevices == null ? false : !hasDevices!,
              onSelected: (b) {
                if (b) {
                  setState(() {
                    hasDevices = false;
                    user.add(
                      UserEntitySearchFiltersChanged(
                        hasDevice: UpdateTo(hasDevices),
                      ),
                    );
                  });
                } else {
                  setState(() {
                    hasDevices = null;
                    user.add(
                      UserEntitySearchFiltersChanged(
                        hasDevice: UpdateTo(hasDevices),
                      ),
                    );
                  });
                }
              },
            ),
          ],
        ),
        ExpansionTile(
          title: Text(context.translate(key: 'filter_by_department')),
          children: [
            Wrap(
              spacing: context.responsive.spacing,
              runSpacing: context.responsive.spacing,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: _buildDepts(depts),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(context.translate(key: 'filter_by_role')),
          children: [
            Wrap(
              spacing: context.responsive.spacing,
              runSpacing: context.responsive.spacing,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: _buildRoles(roles),
            ),
          ],
        ),
      ],
    );
  }

  List<FilterChip> _buildRoles(List<RoleEntity> roles) {
    var user = context.read<UserEntityBloc>();
    return List.generate(roles.length, (i) {
      return FilterChip(
        label: Text(roles[i].name),
        selected: selectedRole == roles[i].id,
        onSelected: (b) {
          setState(() {
            selectedRole = b ? roles[i].id : '';
            user.add(
              UserEntitySearchFiltersChanged(role: UpdateTo(selectedRole)),
            );
          });
        },
      );
    });
  }

  List<FilterChip> _buildDepts(List<DepartmentEntity> depts) { 
    var user = context.read<UserEntityBloc>();
    return List.generate(depts.length, (i) {
      return FilterChip(
        label: Text(depts[i].name),
        selected: selectedDepartment == depts[i].id,
        onSelected: (b) {
          setState(() {
            selectedDepartment = b ? depts[i].id : '';
            user.add(
              UserEntitySearchFiltersChanged(
                department: UpdateTo(selectedDepartment),
              ),
            );
          });
        },
      );
    });
  }
}
