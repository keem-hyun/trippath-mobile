import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RouterExtensions on BuildContext {
  // Navigation helpers
  void goToLogin() => go('/login');
  void goToHome() => go('/home');
  void goToProfile() => go('/profile');
  void goToSearch() => go('/search');
  void goToTrip() => go('/trip');
  void goToTripDetail(String tripId) => go('/trip/$tripId');
  
  // Named navigation
  void goToNamed(String name, {Map<String, String>? params, Map<String, dynamic>? queryParams}) {
    goNamed(name, pathParameters: params ?? {}, queryParameters: queryParams ?? {});
  }
  
  // Push navigation
  Future<T?> pushToLogin<T>() => push<T>('/login');
  Future<T?> pushToHome<T>() => push<T>('/home');
  Future<T?> pushToProfile<T>() => push<T>('/profile');
  Future<T?> pushToSearch<T>() => push<T>('/search');
  Future<T?> pushToTrip<T>() => push<T>('/trip');
  Future<T?> pushToTripDetail<T>(String tripId) => push<T>('/trip/$tripId');
}