import 'package:ai_a11y/data/services/native_overlay_service.dart';
import 'package:ai_a11y/domain/use_case/process_screenshot_use_case.dart';
import 'package:ai_a11y/presentation/features/overlay/state/overlay_state.dart';
import 'package:ai_a11y/presentation/features/overlay/view_model/overlay_view_model.dart';
import 'package:ai_a11y/presentation/features/overlay/widgets/overlay_action_button_widget.dart';
import 'package:ai_a11y/presentation/features/overlay/widgets/overlay_error_widget.dart';
import 'package:ai_a11y/presentation/features/overlay/widgets/overlay_status_text_widget.dart';
import 'package:ai_a11y/presentation/features/overlay/widgets/permissions_section_widget.dart';
import 'package:ai_a11y/presentation/features/overlay/widgets/status_icon_widget.dart';
import 'package:ai_a11y/presentation/root/localization/context_extension.dart';
import 'package:flutter/material.dart' hide OverlayState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final class OverlayPage extends StatelessWidget {
  const OverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider(
      create: (_) => OverlayViewModel(
        overlayService: GetIt.instance<NativeOverlayService>(),
        processScreenshotUseCase: GetIt.instance<ProcessScreenshotUseCase>(),
        localization: locale,
      )..checkPermissions(),
      child: BlocBuilder<OverlayViewModel, OverlayState>(
        builder: (context, state) {
          final viewModel = context.read<OverlayViewModel>();

          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            appBar: AppBar(
              title: Text(locale.common_app_name),
              centerTitle: true,
              backgroundColor: const Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatusIcon(isActive: state.isOverlayActive),
                    const SizedBox(height: 24),
                    OverlayStatusTextWidget(
                      title: state.isOverlayActive
                          ? locale.overlay_status_active
                          : locale.overlay_status_inactive,
                      description: state.isOverlayActive
                          ? locale.overlay_description_active
                          : locale.overlay_description_inactive,
                    ),
                    const SizedBox(height: 48),
                    OverlayActionButtonWidget(
                      isLoading: state.isLoading,
                      isActive: state.isOverlayActive,
                      label: state.isLoading
                          ? locale.overlay_button_loading
                          : state.isOverlayActive
                          ? locale.overlay_button_stop
                          : locale.overlay_button_start,
                      onPressed: viewModel.toggleOverlay,
                    ),
                    if (state.error != null) ...[
                      const SizedBox(height: 24),
                      OverlayErrorWidget(message: state.error!),
                    ],
                    const SizedBox(height: 32),
                    PermissionsSectionWidget(
                      permissions: [
                        (
                          label: locale.overlay_permission_overlay,
                          granted: state.hasOverlayPermission,
                        ),
                        (
                          label: locale.overlay_permission_accessibility,
                          granted: state.hasAccessibilityPermission,
                        ),
                      ],
                    ),
                    if (!state.hasAccessibilityPermission) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: viewModel.requestAccessibilityPermission,
                          icon: const Icon(Icons.accessibility_new_rounded),
                          label: Text(
                            locale.overlay_accessibility_enable_button,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        locale.overlay_accessibility_hint,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
