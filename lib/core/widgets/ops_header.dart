import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_strings.dart';
import '../../app/router/navigation_extensions.dart';
import '../../app/theme/app_colors.dart';
import '../../features/settings/presentation/cubit/language_cubit.dart';

class OpsHeaderAction {
  const OpsHeaderAction.text({required this.label, required this.onPressed})
    : icon = null;

  const OpsHeaderAction.outlined({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
}

class OpsHeader extends StatelessWidget {
  const OpsHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.fallbackRoute,
    this.onBack,
    this.action,
    this.dark = false,
    this.showBack = true,
  });

  final String title;
  final String? subtitle;
  final String? fallbackRoute;
  final VoidCallback? onBack;
  final OpsHeaderAction? action;
  final bool dark;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? Colors.white : AppColors.ink;
    final muted = dark ? Colors.white70 : AppColors.mutedText;
    final language = context.watch<LanguageCubit>().state.languageCode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: Row(
              children: [
                if (showBack)
                  TextButton.icon(
                    onPressed:
                        onBack ??
                        () {
                          final route = fallbackRoute;
                          if (route != null) {
                            context.popOrGo(route);
                          }
                        },
                    icon: Icon(Icons.arrow_back, size: 20, color: muted),
                    label: Text(
                      AppStrings.t('back', language),
                      style: TextStyle(color: muted, fontSize: 16),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                const Spacer(),
                if (action != null) _HeaderAction(action: action!, dark: dark),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: foreground,
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.16,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(color: muted, fontSize: 15, height: 1.35),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.action, required this.dark});

  final OpsHeaderAction action;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final icon = action.icon;
    if (icon == null) {
      return TextButton(
        onPressed: action.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: dark ? Colors.white : AppColors.ink,
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(action.label),
      );
    }

    return OutlinedButton.icon(
      onPressed: action.onPressed,
      icon: Icon(icon, size: 18),
      label: Text(action.label),
      style: OutlinedButton.styleFrom(
        foregroundColor: dark ? Colors.white : AppColors.ink,
        side: BorderSide(color: dark ? Colors.white24 : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
