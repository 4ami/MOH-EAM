part of 'guest_widget.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final UserEntity user;
  
  static Widget get render => const _UserCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      padding: context.responsive.cardPadding,
      decoration: decoration(context),
      child: Column(
        children: [
          _buildDetail(context, 'id', user.id),
          _buildDetail(context, 'full_name_ar', user.fullNameAR ?? 'NA'),
          _buildDetail(context, 'full_name_en', user.fullNameEN ?? 'NA'),
          _buildDetail(context, 'username', user.username),
          _buildDetail(context, 'email', user.email),
          _buildDetail(context, 'mobile', user.mobile.replaceAll('966', '0')),
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


class _UserCardShimmer extends StatefulWidget {
  const _UserCardShimmer();

  @override
  State<_UserCardShimmer> createState() => _UserCardShimmerState();
}

class _UserCardShimmerState extends State<_UserCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
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
              ],
            ),
          );
        },
      ),
    );
  }
}