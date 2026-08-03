import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/app_routes.dart';
import '../widgets/camera_top_bar.dart';
import '../widgets/flash_button.dart';
import '../widgets/flip_camera_button.dart';
import '../widgets/shutter_button.dart';
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
  FlashMode _flashMode = FlashMode.off;

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
      await controller.setFlashMode(_flashMode);

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
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    FlashMode newMode;
    switch (_flashMode) {
      case FlashMode.off:
        newMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newMode = FlashMode.always;
        break;
      case FlashMode.always:
        newMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        newMode = FlashMode.off;
        break;
    }

    try {
      await _controller!.setFlashMode(newMode);
      setState(() => _flashMode = newMode);
    } catch (_) {}
  }

  Future<void> _takePhoto() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        _isTakingPhoto) {
      return;
    }

    setState(() {
      _isTakingPhoto = true;
    });

    try {
      final photo = await controller.takePicture();
      final imageBytes = await photo.readAsBytes();

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoPreviewScreen(imageBytes: imageBytes),
        ),
      );
    } on CameraException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể chụp ảnh: ${error.description ?? error.code}',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể xử lý ảnh: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPhoto = false;
        });
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
      backgroundColor: const Color(0xFF0A0A14),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Friends Pill & Profile Avatar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: CameraTopBar(
                friendCount: _friends.length,
                onFriendsPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Danh sách bạn bè'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                onProfilePressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Trang cá nhân'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),

            // Large Camera Preview Box with Rounded Corners (Radius 28)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildCameraPreview(controller),

                      // Flash Mode Control Widget
                      Positioned(
                        top: 14,
                        left: 14,
                        child: FlashButton(
                          flashMode: _flashMode,
                          onPressed: _toggleFlash,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Camera Capture Controls (Feed shortcut, Shutter button, Flip camera)
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 16, 36, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.feed);
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13132A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2A2A44)),
                      ),
                      child: const Icon(
                        Icons.photo_library_rounded,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ),
                  ),

                  ShutterButton(
                    onPressed: _takePhoto,
                    isLoading: _isTakingPhoto,
                  ),

                  FlipCameraButton(
                    onPressed: _flipCamera,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),

            // Bottom Memories / History Button
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

  Widget _buildHistoryButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.memories);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB800),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB800).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '4',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: 6),
            Text(
              'Lịch sử kỷ niệm',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_up_rounded, color: Colors.black, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A14),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFFFFB800)),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white24,
              size: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'Cần quyền camera',
              style: TextStyle(color: Colors.white70, fontSize: 16),
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
      backgroundColor: const Color(0xFF0A0A14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white24, size: 56),
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
