part of 'utility_helpers.dart';

final class AuthorizationHelper {
  static bool hasMinimumPermission(
    BuildContext context,
    String resource,
    String action,
  ) {
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthenticatedState) return false;
    resource.logWarning(tag: 'Permissions Check');
    if (authState.user.permissions.containsKey(resource)) {
      return authState.user.permissions[resource]!.contains(
        action.toUpperCase(),
      );
    }
    return false;
  }
}
