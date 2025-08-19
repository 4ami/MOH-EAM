part of 'widget_module.dart';

class EntityCard<T extends EntityModel> extends StatelessWidget {
  final T entity;
  final void Function(T entity)? onUpdate;
  final void Function(T entity)? onDelete;
  final void Function(T entity)? onView;

  const EntityCard({
    super.key,
    required this.entity,
    this.onUpdate,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final map = entity.toTableRow();
    final props = entity.columns;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _boxDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translate(key: '${entity.resourceName}_card_title'),
              style: context.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            _sub(props, context, map),

            if (entity is! DeviceEntity) _showMore(context),
          ],
        ),
      ),
    );
  }

  Column _sub(
    List<String> props,
    BuildContext context,
    Map<String, dynamic> map,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: props.map((prop) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              '${context.translate(key: prop)}:',
              style: context.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                decoration: (map[prop] is String && map[prop].isEmpty)
                    ? TextDecoration.lineThrough
                    : null,
              ),
              textScaler: TextScaler.linear(.8),
            ),
            Expanded(child: _buildVal(prop, map[prop], context)),
          ],
        );
      }).toList(),
    );
  }

  SelectableText _buildVal(String key, dynamic value, BuildContext context) {
    if (value == null) {
      return SelectableText('NA', textScaler: TextScaler.linear(.8));
    }

    if (value is String && value.isEmpty) {
      return SelectableText('-', textScaler: TextScaler.linear(.8));
    }

    if (value is bool && key.startsWith('is')) {
      return SelectableText(
        context.translate(key: '${value}_state'),
        textScaler: TextScaler.linear(.8),
        style: context.bodyLarge!.copyWith(
          color: value ? Colors.greenAccent : context.error,
        ),
      );
    }
    return SelectableText(value.toString(), textScaler: TextScaler.linear(.8));
  }

  SizedBox _showMore(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (AuthorizationHelper.hasMinimumPermission(
            context,
            entity.resourceName,
            'VIEW',
          )) {
            if (onView != null) {
              onView?.call(entity);
            } else {
              context.pushNamed(
                AppRoutesInformation.entityViewer.name,
                pathParameters: {
                  "resource": entity.resourceName,
                  "id": entity.toTableRow()['id'] ?? '',
                },
                extra: entity,
              );
            }
            return;
          }
          context.showErrorSnackBar(
            message: context.translate(key: 'insufficient_permissions'),
          );
        },
        child: Text(
          context.translate(key: 'show_more'),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [context.surface, context.surfaceDim],
      ),
      boxShadow: [
        BoxShadow(
          color: context.shadow.withAlpha(50),
          blurRadius: 10,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ],
    );
  }
}
