import 'package:flutter/material.dart';

class PlayerCardInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color accentColor;
  final String hint;

  const PlayerCardInput({
    super.key,
    required this.controller,
    required this.label,
    required this.accentColor,
    required this.hint,
  });

  String _initials(String text) {
    final parts = text.trim().split(RegExp(r"\s+"));
    if (parts.length == 1) {
      return parts.first.isEmpty
          ? '?'
          : parts.first.characters.first.toUpperCase();
    }
    final a = parts.first.characters.isEmpty
        ? ''
        : parts.first.characters.first;
    final b = parts.last.characters.isEmpty ? '' : parts.last.characters.first;
    final s = (a + b).toUpperCase();
    return s.isEmpty ? '?' : s;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderRadius = BorderRadius.circular(12);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: borderRadius,
        border: Border.all(color: accentColor.withOpacity(0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.85),
                    accentColor.withOpacity(0.45),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _initials(controller.text.isEmpty ? hint : controller.text),
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller,
                    maxLength: 24,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      counterText: '',
                      isDense: true,
                      hintText: hint,
                      hintStyle: const TextStyle(color: Colors.white38),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: accentColor.withOpacity(0.8),
                          width: 1.4,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.white54,
                        size: 18,
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 36),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller,
                        builder: (context, value, _) {
                          if (value.text.isEmpty)
                            return const SizedBox(width: 0);
                          return IconButton(
                            tooltip: 'Clear',
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white54,
                            ),
                            onPressed: () => controller.clear(),
                          );
                        },
                      ),
                    ),
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
