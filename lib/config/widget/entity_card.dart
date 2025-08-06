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

            _showMore(context),
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
          children: [
            SelectableText(
              '${context.translate(key: prop)}:',
              style: context.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            SelectableText(
              map[prop].toString(),
              textScaler: TextScaler.linear(.8),
            ),
          ],
        );
      }).toList(),
    );
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
