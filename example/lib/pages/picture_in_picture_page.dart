import 'package:better_player_example/constants.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

class PictureInPicturePage extends StatefulWidget {
  const PictureInPicturePage({super.key});

  @override
  State<PictureInPicturePage> createState() => _PictureInPicturePageState();
}

class _PictureInPicturePageState extends State<PictureInPicturePage> {
  late BetterPlayerController _betterPlayerController;
  final GlobalKey _betterPlayerKey = GlobalKey();
  bool _automaticPipEnabled = false;
  bool _isAutomaticPipSupported = false;
  bool _isPipSupported = false;

  @override
  void initState() {
    const BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Constants.elephantDreamVideoUrl,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource).then((_) {
      _checkPipSupport();
    });
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    super.initState();
  }

  Future<void> _checkPipSupport() async {
    final isPipSupported = await _betterPlayerController.isPictureInPictureSupported();
    final isAutoPipSupported = await _betterPlayerController.isAutomaticPictureInPictureSupported();
    if (mounted) {
      setState(() {
        _isPipSupported = isPipSupported;
        _isAutomaticPipSupported = isAutoPipSupported;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Picture in Picture player')),
    body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Example which shows how to use PiP.', style: TextStyle(fontSize: 16)),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController, key: _betterPlayerKey),
          ),
          const SizedBox(height: 16),
          // PiP Support Status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PiP Supported: ${_isPipSupported ? "Yes" : "No"}',
                  style: TextStyle(fontSize: 14, color: _isPipSupported ? Colors.green : Colors.red),
                ),
                Text(
                  'Automatic PiP Supported: ${_isAutomaticPipSupported ? "Yes" : "No"}',
                  style: TextStyle(fontSize: 14, color: _isAutomaticPipSupported ? Colors.green : Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Manual PiP Controls
          const Text('Manual PiP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isPipSupported
                    ? () => _betterPlayerController.enablePictureInPicture(_betterPlayerKey)
                    : null,
                child: const Text('Show PiP'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isPipSupported ? () => _betterPlayerController.disablePictureInPicture() : null,
                child: const Text('Disable PiP'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Automatic PiP Controls
          const Text('Automatic PiP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Auto-enter PiP on background:', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Switch(
                  value: _automaticPipEnabled,
                  onChanged: _isAutomaticPipSupported
                      ? (value) {
                          setState(() => _automaticPipEnabled = value);
                          _betterPlayerController.setAutomaticPictureInPictureEnabled(value);
                        }
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }
}
