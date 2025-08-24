part of 'guest_widget.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device});
  final DeviceEntity device;

  static Widget get render => const _DeviceCardShimmer();

  @override
  Widget build(BuildContext context) {
    var t = context.translate;

    var inDomain = t(key: '${device.inDomain.toString().toLowerCase()}_state');
    var kasper = t(
      key: '${device.kasperInstalled.toString().toLowerCase()}_state',
    );
    var cs = t(
      key: '${device.crowdStrikeInstalled.toString().toLowerCase()}_state',
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      padding: context.responsive.cardPadding,
      decoration: decoration(context),
      child: Column(
        children: [
          _buildDetail(context, 'id', device.id),
          _buildDetail(context, 'serial', device.serial),
          _buildDetail(context, 'model', device.model),
          _buildDetail(context, 'type', device.type),
          _buildDetail(context, 'host_name', device.hostName ?? '-'),
          _buildDetail(context, 'is_in_domain?', inDomain),
          _buildDetail(context, 'is_kasper_installed?', kasper),
          _buildDetail(context, 'is_crowdstrike_installed?', cs),
        ],
      ),
    );
  }

  Row _buildDetail(BuildContext context, String label, String detail) {
    var t = context.translate;
    return Row(
      children: [
        SelectableText("${t(key: label)}: "),
        Expanded(child: SelectableText(detail)),
      ],
    );
  }

  BoxDecoration decoration(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: shadow(context),
    );
  }

  List<BoxShadow> shadow(BuildContext context) {
    var isLight = context.read<ThemeCubit>().isLight;
    return [
      BoxShadow(
        color: isLight
            ? Colors.grey.shade100.withAlpha(50)
            : context.shadow.withAlpha(50),
        blurRadius: 15,
        spreadRadius: .1,
        offset: -const Offset(5, 5),
        blurStyle: BlurStyle.inner,
      ),
      BoxShadow(
        color: context.shadow.withAlpha(10),
        blurRadius: 32,
        offset: const Offset(5, 5),
        blurStyle: BlurStyle.outer,
      ),
    ];
  }
}

class _DeviceCardShimmer extends StatefulWidget {
  const _DeviceCardShimmer();

  @override
  State<_DeviceCardShimmer> createState() => _DeviceCardShimmerState();
}

class _DeviceCardShimmerState extends State<_DeviceCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _line({double height = 14, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      padding: context.responsive.cardPadding,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment(-1.0, -0.3),
                end: Alignment(1.0, 0.3),
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade100,
                  Colors.grey.shade300,
                ],
                stops: [
                  (_controller.value - 0.3).clamp(0.0, 1.0),
                  _controller.value.clamp(0.0, 1.0),
                  (_controller.value + 0.3).clamp(0.0, 1.0),
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode.srcATop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 80),
                _line(),
                _line(),
                _line(),
                _line(),
                _line(),
                _line(),
                _line(),
              ],
            ),
          );
        },
      ),
    );
  }
}
