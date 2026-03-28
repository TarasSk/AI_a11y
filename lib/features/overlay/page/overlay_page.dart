import 'package:ai_a11y/app/localization/context_extension.dart';
import 'package:ai_a11y/features/overlay/widgets/overlay_action_button_widget.dart';
import 'package:ai_a11y/features/overlay/widgets/overlay_error_widget.dart';
import 'package:ai_a11y/features/overlay/widgets/overlay_status_text_widget.dart';
import 'package:ai_a11y/features/overlay/widgets/permissions_section_widget.dart';
import 'package:ai_a11y/features/overlay/widgets/status_icon_widget.dart';
import 'package:flutter/material.dart' hide OverlayState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_a11y/features/overlay/state/overlay_state.dart';
import 'package:ai_a11y/features/overlay/view_model/overlay_view_model.dart';
import 'package:ai_a11y/services/native_overlay_service.dart';

final class OverlayPage extends StatelessWidget {
  const OverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider(
      create: (_) => OverlayViewModel(
        overlayService: GetIt.instance<NativeOverlayService>(),
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
                      ],
                    ),
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
