import 'package:flutter/material.dart';

InputDecoration getInputDecoration(String labelText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      label: Text(labelText),
      labelStyle: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
      errorStyle: const TextStyle(height: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white30, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white30, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white30, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }