sealed class DeviceFilterValue<T> {
  const DeviceFilterValue();
}

final class UpdateDeviceFilterTo<T> extends DeviceFilterValue<T> {
  final T value;
  const UpdateDeviceFilterTo(this.value);
}

class DeviceFilters {
  final int page, limit;
  final String? query;
  final bool? inDomain, kasperInstalled, crowdStrikeInstalled;

  const DeviceFilters({
    this.page = 1,
    this.limit = 15,
    this.query,
    this.inDomain,
    this.kasperInstalled,
    this.crowdStrikeInstalled,
  });

  DeviceFilters copyWith({
    DeviceFilterValue<int?>? page,
    DeviceFilterValue<int?>? limit,
    DeviceFilterValue<String?>? query,
    DeviceFilterValue<bool?>? inDomain,
    DeviceFilterValue<bool?>? kasperInstalled,
    DeviceFilterValue<bool?>? crowdStrikeInstalled,
  }) {
    return DeviceFilters(
      page: checkAndUpdate<int>(page, this.page) ?? this.page,
      limit: checkAndUpdate<int>(limit, this.limit) ?? this.limit,
      query: checkAndUpdate<String?>(query, this.query),
      inDomain: checkAndUpdate<bool?>(inDomain, this.inDomain),
      kasperInstalled: checkAndUpdate<bool?>(
        kasperInstalled,
        this.kasperInstalled,
      ),
      crowdStrikeInstalled: checkAndUpdate<bool?>(
        crowdStrikeInstalled,
        this.crowdStrikeInstalled,
      ),
    );
  }

  T? checkAndUpdate<T>(DeviceFilterValue? v, T? actual) {
    return v is UpdateDeviceFilterTo<T?> ? v.value : actual;
  }

  Map<String, dynamic> toQueryParams() {
    return {
      "page": Uri.encodeQueryComponent(page.toString()),
      "limit": Uri.encodeQueryComponent(limit.toString()),
      if (query != null) "query": Uri.encodeQueryComponent(query!),
      if (inDomain != null)
        "in_domain": Uri.encodeQueryComponent(inDomain.toString()),
      if (kasperInstalled != null)
        "kasper_installed": Uri.encodeQueryComponent(
          kasperInstalled.toString(),
        ),
      if (crowdStrikeInstalled != null)
        "crowdstrike_installed": Uri.encodeQueryComponent(
          crowdStrikeInstalled.toString(),
        ),
    };
  }
}
