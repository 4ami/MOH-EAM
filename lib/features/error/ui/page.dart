library;

import 'package:flutter/material.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
part 'widgets/button.dart';

class ErrorPage extends StatelessWidget {
  final String? errorCode;
  final String? errorMessage;
  final String? errorTitle;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;

  const ErrorPage({
    super.key,
    this.errorCode,
    this.errorMessage,
    this.errorTitle,
    this.onRetry,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      body: Container(
        decoration: _decoration(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.primary.withValues(alpha: .1),
                              context.secondary.withValues(alpha: .1),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.primary.withValues(alpha: .1),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background circles
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: context.primary.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Main icon
                            Icon(
                              Icons.sentiment_dissatisfied_rounded,
                              size: 80,
                              color: context.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                if (errorCode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: context.errorContainer.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: context.error.withValues(alpha: .3),
                      ),
                    ),
                    child: Text(
                      errorCode!,
                      style: context.h6?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.error,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                _maskedTitle(context),

                _messageContainer(context),

                _actions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _actions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onGoHome != null)
          _Button(
            onPressed: onGoHome!,
            icon: Icons.home_rounded,
            label: context.translate(key: 'go_home'),
            isPrimary: true,
          ),

        if (onGoHome != null && onRetry != null) const SizedBox(width: 16),

        if (onRetry != null)
          _Button(
            onPressed: onRetry!,
            icon: Icons.refresh_rounded,
            label: context.translate(key: 'retry'),
            isPrimary: false,
          ),
      ],
    );
  }

  Container _messageContainer(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Text(
        errorMessage ??
            context.translate(key: 'default_navigation_error_message'),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: context.onSurfaceVariant,
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  ShaderMask _maskedTitle(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [context.primary, context.secondary],
      ).createShader(bounds),
      child: Text(
        errorTitle ?? context.translate(key: 'error_page_title'),
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  BoxDecoration _decoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [context.surface, context.surfaceTint.withValues(alpha: .3)],
      ),
    );
  }
}
