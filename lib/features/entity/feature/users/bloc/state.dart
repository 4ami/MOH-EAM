part of 'bloc.dart';

final class UserEntityState {
  final UserEntityEvent event;
  final List<UserEntity> users;
  final int maxPage;
  final UserEntity? user;
  final SearchFilters filters;

  const UserEntityState({
    this.event = const UserEntityInitialEvent(),
    this.users = const [],
    this.maxPage = 0,
    this.filters = const SearchFilters(),
    this.user,
  });

  UserEntityState copyWith({
    UserEntityEvent? event,
    List<UserEntity>? users,
    int? maxPage,
    UserEntity? user,
    FilterValue<int?>? page,
    FilterValue<int?>? limit,
    FilterValue<String?>? query,
    FilterValue<String?>? locale,
    FilterValue<String?>? role,
    FilterValue<String?>? department,
    FilterValue<bool?>? hasDevice,
  }) {
    return UserEntityState(
      event: event ?? this.event,
      users: users ?? this.users,
      maxPage: maxPage ?? this.maxPage,
      user: user ?? this.user,
      filters: filters.copyWith(
        query: query,
        page: page,
        limit: limit,
        locale: locale,
        role: role,
        department: department,
        hasDevice: hasDevice,
      ),
    );
  }
}

sealed class FilterValue<T> {
  const FilterValue();
}

final class KeepCurrent<T> extends FilterValue<T> {
  const KeepCurrent();
}

final class UpdateTo<T> extends FilterValue<T> {
  final T value;
  const UpdateTo(this.value);
}

final class SearchFilters {
  final String? locale, role, department, query;
  final bool? hasDevice;
  final int page;
  final int limit;

  const SearchFilters({
    this.query,
    this.page = 1,
    this.limit = 15,
    this.locale = 'ar',
    this.role,
    this.department,
    this.hasDevice,
  });

  SearchFilters copyWith({
    FilterValue<String?>? query,
    FilterValue<int?>? page,
    FilterValue<int?>? limit,
    FilterValue<String?>? locale,
    FilterValue<String?>? role,
    FilterValue<String?>? department,
    FilterValue<bool?>? hasDevice,
  }) {
    return SearchFilters(
      query: query is UpdateTo<String?> ? query.value : this.query,
      page: page is UpdateTo<int?> ? (page.value ?? this.page) : this.page,
      limit: limit is UpdateTo<int?> ? (limit.value ?? this.limit) : this.limit,
      locale: locale is UpdateTo<String?> ? locale.value : this.locale,
      role: role is UpdateTo<String?> ? role.value : this.role,
      department: department is UpdateTo<String?>
          ? department.value
          : this.department,
      hasDevice: hasDevice is UpdateTo<bool?>
          ? hasDevice.value
          : this.hasDevice,
    );
  }

  SearchFilters clearFilters() {
    return copyWith(
      query: UpdateTo(null),
      role: UpdateTo(null),
      department: UpdateTo(null),
      hasDevice: UpdateTo(null),
    );
  }

  SearchFilters reset() {
    return const SearchFilters();
  }

  @override
  String toString() {
    return "SearchFilters(\nquery: $query,\npage:$page,\nlimit:$limit,\nlocale:$locale,\nrole:$role,\ndepartment:$department,\nhasDevice:$hasDevice,\n)";
  }
}
