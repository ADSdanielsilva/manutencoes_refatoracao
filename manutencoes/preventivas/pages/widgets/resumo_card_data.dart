import 'package:flutter/material.dart';

class ResumoCardData {
  final String title;
  final IconData icon;

  final Color iconBg;
  final Color iconColor;

  final String value;

  const ResumoCardData({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.value = '',
  });

  ResumoCardData copyWith({
    String? title,
    IconData? icon,
    Color? iconBg,
    Color? iconColor,
    String? value,
  }) {
    return ResumoCardData(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      iconBg: iconBg ?? this.iconBg,
      iconColor: iconColor ?? this.iconColor,
      value: value ?? this.value,
    );
  }
}
