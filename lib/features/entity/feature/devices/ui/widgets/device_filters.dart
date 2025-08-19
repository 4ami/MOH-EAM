part of 'device_widgets_module.dart';

class DeviceFiltersWidget extends StatefulWidget {
  const DeviceFiltersWidget({super.key});

  @override
  State<DeviceFiltersWidget> createState() => _DeviceFiltersWidgetState();
}

class _DeviceFiltersWidgetState extends State<DeviceFiltersWidget> {
  bool? inDomain, kasperInstalled, crowdStrikeInstalled;

  @override
  Widget build(BuildContext context) {
    var deviceBloc = context.read<DeviceBloc>();
    return Column(
      spacing: 15,
      children: [
        _domainFilter(deviceBloc),
        _kasperFilter(deviceBloc),
        _crowdStrikeFilter(deviceBloc),
      ],
    );
  }

  ExpansionTile _domainFilter(DeviceBloc state) {
    return ExpansionTile(
      title: Text(context.translate(key: 'device_domain_filter')),
      children: [
        FilterChip(
          selected: inDomain ?? false,
          label: Text(context.translate(key: 'device_in_domain_filter_value')),
          onSelected: (i) {
            setState(() {
              inDomain = i ? i : null;
              var filters = state.state.filters;
              state.add(
                UpdateDeviceFilters(
                  filters: filters.copyWith(
                    inDomain: UpdateDeviceFilterTo(inDomain),
                  ),
                ),
              );
            });
          },
        ),

        FilterChip(
          selected: inDomain == null ? false : !inDomain!,
          label: Text(
            context.translate(key: 'device_not_in_domain_filter_value'),
          ),
          onSelected: (n) {
            setState(() {
              inDomain = n ? !n : null;
              var filters = state.state.filters;
              state.add(
                UpdateDeviceFilters(
                  filters: filters.copyWith(
                    inDomain: UpdateDeviceFilterTo(inDomain),
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }

  ExpansionTile _kasperFilter(DeviceBloc state) {
    return ExpansionTile(
      title: Text(context.translate(key: 'device_kasper_filter')),
      children: [
        FilterChip(
          selected: kasperInstalled ?? false,
          label: Text(
            context.translate(key: 'device_kasper_installed_filter_value'),
          ),
          onSelected: (i) {
            setState(() {
              kasperInstalled = i ? i : null;
              var filters = state.state.filters;
              state.add(
                UpdateDeviceFilters(
                  filters: filters.copyWith(
                    kasperInstalled: UpdateDeviceFilterTo(kasperInstalled),
                  ),
                ),
              );
            });
          },
        ),

        FilterChip(
          selected: kasperInstalled == null ? false : !kasperInstalled!,
          label: Text(
            context.translate(key: 'device_kasper_not_installed_filter_value'),
          ),
          onSelected: (n) {
            setState(() {
              kasperInstalled = n ? !n : null;
              var filters = state.state.filters;
              state.add(
                UpdateDeviceFilters(
                  filters: filters.copyWith(
                    kasperInstalled: UpdateDeviceFilterTo(kasperInstalled),
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }

  ExpansionTile _crowdStrikeFilter(DeviceBloc state) {
    return ExpansionTile(
      title: Text(context.translate(key: 'device_crowdstrike_filter')),
      children: [
        FilterChip(
          selected: crowdStrikeInstalled ?? false,
          label: Text(
            context.translate(key: 'device_crowdstrike_installed_filter_value'),
          ),
          onSelected: (i) {
            setState(() {
              crowdStrikeInstalled = i ? i : null;
              var filters = state.state.filters;
              state.add(
                UpdateDeviceFilters(
                  filters: filters.copyWith(
                    crowdStrikeInstalled: UpdateDeviceFilterTo(
                      crowdStrikeInstalled,
                    ),
                  ),
                ),
              );
            });
          },
        ),

        FilterChip(
          selected: crowdStrikeInstalled == null
              ? false
              : !crowdStrikeInstalled!,
          label: Text(
            context.translate(
              key: 'device_crowdstrike_not_installed_filter_value',
            ),
          ),
          onSelected: (n) {
            setState(() {
              crowdStrikeInstalled = n ? !n : null;
              var filters = state.state.filters;
              state.add(
                UpdateDeviceFilters(
                  filters: filters.copyWith(
                    crowdStrikeInstalled: UpdateDeviceFilterTo(
                      crowdStrikeInstalled,
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }
}
