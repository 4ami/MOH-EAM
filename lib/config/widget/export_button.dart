part of 'widget_module.dart';

class ExportButton extends StatefulWidget {
  const ExportButton({
    super.key,
    required this.labelKey,
    required this.onPressed,
    this.progress,
  });

  final String labelKey;
  final VoidCallback onPressed;
  final double? progress;
  @override
  State<ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton> {
  @override
  Widget build(BuildContext context) {
    var t = context.translate;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25, horizontal: context.padding),
      child: FilledButton.icon(
        onPressed: widget.onPressed,
        label: Text(t(key: widget.labelKey)),
        icon: _showDownload(),
      ),
    );
  }

  Widget _showDownload() {
    if (widget.progress == null) return Icon(Icons.download_rounded);
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: context.onPrimary,
        value: widget.progress,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
