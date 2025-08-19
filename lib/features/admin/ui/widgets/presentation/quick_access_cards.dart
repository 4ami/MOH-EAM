part of '../admin_widgets_module.dart';

class QuickAccessCards extends StatelessWidget {
  const QuickAccessCards({super.key});

  @override
  Widget build(BuildContext context) {
    var t = context.translate;
    var w = context.watch<AdminBloc>().state;
    return Wrap(
      spacing: context.responsive.spacing,
      runSpacing: context.responsive.spacing,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        //Users data
        _buildCard(
          context,
          count: w.totalUsers,
          label: t(key: 'total_users'),
        ),
        // GestureDetector(
        //   onTap: () =>
        //       context.pushNamed(AppRoutesInformation.userManagement.name),
        //   child: _buildCard(
        //     context,
        //     icon: AssetsHelper.usersIcon,
        //     label: t(key: 'users_quick_access'),
        //   ),
        // ),
        //Devices data
        _buildCard(
          context,
          count: w.totalDevices,
          label: t(key: 'total_devices'),
        ),
        // _buildCard(
        //   context,
        //   icon: AssetsHelper.devicesIcon,
        //   label: t(key: 'devices_quick_access'),
        // ),
        //Department data
        // _buildCard(
        //   context,
        //   icon: AssetsHelper.departmentsIcon,
        //   label: t(key: 'departments_quick_access'),
        // ),
      ],
    );
  }

  // Widget _buildCard(
  //   BuildContext context, {
  //   required String icon,
  //   required String label,
  // }) {
  //   return CustomCard(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       spacing: 10,
  //       children: [
  //         Image.asset(icon, scale: context.responsive.scale(5, .8)),
  //         Text(label, overflow: TextOverflow.ellipsis),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildCard(
    BuildContext context, {
    required String label,
    required int count,
  }) {
    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: context.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(count.toString(), style: context.bodyLarge),
        ],
      ),
    );
  }
}
