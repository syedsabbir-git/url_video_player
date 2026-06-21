import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class VideoLoadingOverlay extends StatelessWidget {
  final bool visible;
  final Widget? customWidget;

  const VideoLoadingOverlay({
    super.key,
    required this.visible,
    this.customWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: visible
          ? (customWidget ?? const _VideoPlayerSkeleton())
          : const SizedBox.shrink(),
    );
  }
}

class _VideoPlayerSkeleton extends StatelessWidget {
  const _VideoPlayerSkeleton();

  @override
  Widget build(BuildContext context) {
    const shimmerColor = Color(0xFF2A2A2A);

    return Container(
      color: Colors.black,
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: shimmerColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 10,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const Spacer(),
                      for (int i = 0; i < 3; i++) ...[
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: shimmerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (i < 2) const SizedBox(width: 14),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
