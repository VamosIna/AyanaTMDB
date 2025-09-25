import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({Key? key}) : super(key: key);

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _isOffline = false;
  late final Connectivity _connectivity;
  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final connectivity = (result.isNotEmpty)
          ? result.first
          : (result is ConnectivityResult ? result : ConnectivityResult.none);
      setState(() {
        _isOffline = connectivity == ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOffline) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: Colors.redAccent,
      padding: const EdgeInsets.all(8),
      child: const SafeArea(
        child: Text(
          'You are offline',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
