import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/app_routes.dart';
import '../../friends/services/friend_service.dart';
import '../../history/services/history_service.dart';
import 'send_photo_screen.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isLoading = true;
  bool _permissionDenied = false;
  bool _isTakingPhoto = false;
  int _currentCameraIndex = 0;
  bool _flashOn = false;

  // Animation cho nút chụp
  late AnimationController _shutterAnim;
  late Animation<double> _shutterScale;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    HistoryService.instance.addListener(_onHistoryChanged);
    _shutterAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _shutterScale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _shutterAnim, curve: Curves.easeInOut),
    );
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HistoryService.instance.removeListener(_onHistoryChanged);
    _shutterAnim.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onHistoryChanged() {
    if (mounted) setState(() {});
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    setState(() => _isLoading = true);
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() {
        _permissionDenied = true;
        _isLoading = false;
      });
      return;
    }
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<void> _startCamera(CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;
    _currentCameraIndex = _currentCameraIndex == 0 ? 1 : 0;
    await _controller?.dispose();
    setState(() => _isLoading = true);
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  void _toggleFlash() {
    if (_controller == null) return;
    setState(() => _flashOn = !_flashOn);
    _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isTakingPhoto) return;
    // Animate shutter
    await _shutterAnim.forward();
    await _shutterAnim.reverse();
    setState(() => _isTakingPhoto = true);
    try {
      final XFile photo = await _controller!.takePicture();
      final bytes = await photo.readAsBytes();
      if (!mounted) return;
      setState(() => _isTakingPhoto = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SendPhotoScreen(
            imageBytes: bytes,
            imagePath: photo.path,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isTakingPhoto = false);
    }
  }


  // ─────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) return _buildPermissionDenied();
    if (_isLoading) return _buildLoading();
    if (_controller == null) return _buildError();

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -150) {
            // Swipe UP -> History Photo Feed Screen
            Navigator.pushNamed(context, AppRoutes.historyFeed);
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 150) {
            // Swipe right -> Memories (Kỷ niệm calendar)
            Navigator.pushNamed(context, AppRoutes.memories);
          } else if (details.primaryVelocity != null &&
              details.primaryVelocity! < -150) {
            // Swipe left -> Feed / Messaging
            Navigator.pushNamed(context, AppRoutes.feed);
          }
        },

        child: SafeArea(
          child: Column(
            children: [
              // ── TOP BAR ──────────────────────────────────
              _buildTopBar(),

              const Spacer(),

              // ── VIEWFINDER (SQUARE) ──────────────────────
              _buildViewfinder(),

              const Spacer(),

              // ── CONTROLS ─────────────────────────────────
              _buildControls(),

              const SizedBox(height: 8),

              // ── LỊCH SỬ ──────────────────────────────────
              _buildHistoryRow(),

              const SizedBox(height: 14),

              // ── BOTTOM DOCK ──────────────────────────────
              _buildBottomDock(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

  }

  // ─── Top Bar ───────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          // Announcement / Speaker icon (left)
          _topIconBtn(
            icon: Icons.campaign_outlined,
            onTap: () {},
          ),

          const Spacer(),

          // Friends pill (center)
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.friends),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(22),
              ),
              child: AnimatedBuilder(
                animation: FriendService.instance,
                builder: (context, _) {
                  final count = FriendService.instance.friendCount;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '$count người bạn',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const Spacer(),

          // Avatar (right) — navigate to profile
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30, width: 2),
                color: const Color(0xFF2C2C2E),
              ),
              child: ClipOval(
                child: _AvatarPlaceholder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Viewfinder (Square 1:1) ───────────────────────
  Widget _buildViewfinder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Camera preview — fill & cover
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize!.height,
                  height: _controller!.value.previewSize!.width,
                  child: CameraPreview(_controller!),
                ),
              ),

              // Flash button — top left
              Positioned(
                top: 14,
                left: 14,
                child: GestureDetector(
                  onTap: _toggleFlash,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _flashOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      color:
                          _flashOn ? const Color(0xFFFFB800) : Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),

              // Zoom badge — top right
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    '1×',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Bottom Navigation Dock ───────────────────────
  Widget _buildBottomDock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left: Photo History (Lịch sử ảnh đã chụp)
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.memories),
            icon: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white60,
              size: 22,
            ),
          ),
          const SizedBox(width: 6),

          // Center: Home (Camera Screen - current screen)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.home_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 6),

          // Right: Messaging / Chat Screen
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.feed),
            icon: const Icon(
              Icons.chat_bubble_rounded,
              color: Colors.white60,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }


  // ─── Controls row ──────────────────────────────────
  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(44, 22, 44, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gallery / last photo thumbnail
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: const Icon(
                  Icons.photo_library_rounded,
                  color: Colors.white54,
                  size: 26,
                ),
              ),
            ),
          ),

          // Shutter button — white circle + yellow ring
          GestureDetector(
            onTap: _isTakingPhoto ? null : _takePhoto,
            child: ScaleTransition(
              scale: _shutterScale,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFB800),
                    width: 4.5,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Flip camera
          GestureDetector(
            onTap: _flipCamera,
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flip_camera_ios_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── History row ───────────────────────────────────
  Widget _buildHistoryRow() {
    final photos = HistoryService.instance.photos;
    final latestPhoto = photos.isNotEmpty ? photos.last : null;

    Widget thumb;
    if (latestPhoto != null) {
      final path = latestPhoto.imagePath;
      if (path.startsWith('lib/') || path.startsWith('assets/')) {
        thumb = Image.asset(path, fit: BoxFit.cover);
      } else if (File(path).existsSync()) {
        thumb = Image.file(File(path), fit: BoxFit.cover);
      } else {
        thumb = const Icon(Icons.photo_rounded, color: Colors.white38, size: 18);
      }
    } else {
      thumb = const Icon(Icons.photo_rounded, color: Colors.white38, size: 18);
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.historyFeed),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mini thumbnail
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: thumb,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Lịch sử',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }


  // ─── Helpers ───────────────────────────────────────
  Widget _topIconBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }

  // ─── State screens ─────────────────────────────────
  Widget _buildLoading() => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFB800),
            strokeWidth: 2.5,
          ),
        ),
      );

  Widget _buildPermissionDenied() => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined,
                  color: Colors.white24, size: 56),
              const SizedBox(height: 16),
              const Text('Cần quyền truy cập camera',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: openAppSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                ),
                child: const Text('Mở Cài đặt',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );

  Widget _buildError() => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Colors.white24, size: 56),
              const SizedBox(height: 16),
              const Text('Không mở được camera',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                ),
                child: const Text('Thử lại',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );
}

// ── Avatar placeholder ─────────────────────────────────
class _AvatarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3A3A3C),
      child: const Icon(Icons.person_rounded, color: Colors.white54, size: 22),
    );
  }
}