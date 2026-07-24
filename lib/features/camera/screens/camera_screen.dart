import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'photo_preview_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  bool _isLoading = true;
  bool _permissionDenied = false;
  bool _isTakingPhoto = false;
  int _currentCameraIndex = 0;

  final List<Map<String, String>> _friends = const [
    {'name': 'Tân', 'avatar': 'DTT'},
    {'name': 'Nam', 'avatar': 'TN'},
    {'name': 'Thắng', 'avatar': 'XT'},
    {'name': 'An Thuyên', 'avatar': '29C1'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _permissionDenied = false;
      });
    }

    final status = await Permission.camera.request();

    if (!status.isGranted) {
      if (!mounted) return;
      setState(() {
        _permissionDenied = true;
        _isLoading = false;
      });
      return;
    }

    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        return;
      }

      if (_currentCameraIndex >= _cameras.length) {
        _currentCameraIndex = 0;
      }

      await _startCamera(_cameras[_currentCameraIndex]);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _startCamera(CameraDescription camera) async {
    final oldController = _controller;
    _controller = null;
    await oldController?.dispose();

    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isLoading = false;
      });
    } catch (_) {
      await controller.dispose();

      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2 || _isLoading || _isTakingPhoto) {
      return;
    }

    setState(() => _isLoading = true);

    _currentCameraIndex =
        (_currentCameraIndex + 1) % _cameras.length;

    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<void> _takePhoto() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        _isTakingPhoto) {
      return;
    }

    setState(() => _isTakingPhoto = true);

    try {
      final photo = await controller.takePicture();
      final imageBytes = await photo.readAsBytes();

      if (!mounted) return;

      await Navigator.push(
        context,
  MaterialPageRoute(
    builder: (context) => PhotoPreviewScreen(
      imageBytes: imageBytes,
    ),
  ),
);
    } on CameraException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể chụp ảnh: ${error.description ?? error.code}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isTakingPhoto = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) return _buildPermissionDenied();
    if (_isLoading) return _buildLoading();

    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return _buildError();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildCameraPreview(controller),
                      Positioned(
                        top: 14,
                        left: 14,
                        child: _cameraButton(
                          Icons.flash_off,
                          () {},
                        ),
                      ),
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '1×',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildControls(),
            _buildHistoryButton(),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview(CameraController controller) {
    final previewSize = controller.value.previewSize;

    if (previewSize == null) {
      return const ColoredBox(color: Colors.black);
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: previewSize.height,
        height: previewSize.width,
        child: CameraPreview(controller),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _iconButton(Icons.notifications_off_outlined, () {}),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${_friends.length} người bạn',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
              color: const Color(0xFF7F77DD)
                  .withValues(alpha: 0.3),
            ),
            child: const Center(
              child: Text(
                'Tôi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white54,
              size: 24,
            ),
          ),
          GestureDetector(
            onTap: _isTakingPhoto ? null : _takePhoto,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              width: _isTakingPhoto ? 72 : 78,
              height: _isTakingPhoto ? 72 : 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFB800),
                  width: 4,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  width: _isTakingPhoto ? 58 : 64,
                  height: _isTakingPhoto ? 58 : 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _flipCamera,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(
                Icons.flip_camera_ios_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB800),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '4',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 6),
            Text(
              'Lịch sử',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _cameraButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFFB800),
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white24,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Cần quyền camera',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: openAppSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
              ),
              child: const Text(
                'Mở Cài đặt',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white24,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Không mở được camera',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
              ),
              child: const Text(
                'Thử lại',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
