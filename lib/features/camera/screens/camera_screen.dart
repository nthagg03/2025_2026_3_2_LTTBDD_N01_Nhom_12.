import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/app_routes.dart';

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

  // Danh sách bạn bè giả (sau này lấy từ API)
  final List<Map<String, String>> _friends = [
    {'name': 'An', 'avatar': 'AN'},
    {'name': 'Bình', 'avatar': 'BT'},
    {'name': 'Hà', 'avatar': 'HN'},
    {'name': 'Tú', 'avatar': 'TU'},
    {'name': 'Minh', 'avatar': 'MN'},
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
      setState(() { _permissionDenied = true; _isLoading = false; });
      return;
    }
    _cameras = await availableCameras();
    if (_cameras.isEmpty) { setState(() => _isLoading = false); return; }
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<void> _startCamera(CameraDescription camera) async {
    final controller = CameraController(
      camera, ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() { _controller = controller; _isLoading = false; });
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

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isTakingPhoto) return;
    setState(() => _isTakingPhoto = true);
    try {
      final XFile photo = await _controller!.takePicture();
      setState(() => _isTakingPhoto = false);
      _showPreview(photo.path);
    } catch (e) {
      setState(() => _isTakingPhoto = false);
    }
  }

  void _showPreview(String path) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: Stack(
          children: [
            // Ảnh preview bo góc
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  path, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(path, fit: BoxFit.cover),
                ),
              ),
            ),
            // Gradient dưới
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
              ),
            ),
            // 2 nút dưới cùng
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Row(
                    children: [
                      // Chụp lại
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Center(
                              child: Text('Chụp lại',
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 15, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Gửi
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Đã đăng! AI đang xử lý từ vựng...'),
                                backgroundColor: Color(0xFF7F77DD),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB800), // Vàng như Locket
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: const Center(
                              child: Text('Gửi cho bạn bè 🚀',
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 15, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) return _buildPermissionDenied();
    if (_isLoading) return _buildLoading();
    if (_controller == null) return _buildError();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [

            // ── TOP BAR ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  // Nút thông báo
                  _iconBtn(Icons.notifications_off_outlined, () {}),
                  const Spacer(),
                  // Số bạn bè — giống Locket
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.friends),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text('${_friends.length} người bạn',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Avatar bản thân
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                        color: const Color(0xFF7F77DD).withValues(alpha: 0.3),
                      ),
                      child: const Center(
                        child: Text('Tôi',
                            style: TextStyle(color: Colors.white, fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── VIEWFINDER bo góc như Locket ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    children: [
                      // Camera preview
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller!.value.previewSize!.height,
                            height: _controller!.value.previewSize!.width,
                            child: CameraPreview(_controller!),
                          ),
                        ),
                      ),
                      // Flash + zoom badge
                      Positioned(
                        top: 14, left: 14,
                        child: _cameraBtn(Icons.flash_off, () {}),
                      ),
                      Positioned(
                        top: 14, right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('1×',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── CONTROLS ──
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Thumb ảnh gần nhất / thư viện
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.photo_library_outlined,
                          color: Colors.white54, size: 24),
                    ),
                  ),

                  // Nút chụp — vàng như Locket
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

                  // Lật camera
                  GestureDetector(
                    onTap: _flipCamera,
                    child: Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.flip_camera_ios_outlined,
                          color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            // ── LỊCH SỬ ảnh đã gửi ──
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('4',
                        style: TextStyle(color: Colors.black,
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    SizedBox(width: 6),
                    Text('Lịch sử',
                        style: TextStyle(color: Colors.black,
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down,
                        color: Colors.black, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _cameraBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildLoading() => const Scaffold(
    backgroundColor: Colors.black,
    body: Center(child: CircularProgressIndicator(color: Color(0xFFFFB800))),
  );

  Widget _buildPermissionDenied() => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.camera_alt_outlined, color: Colors.white24, size: 48),
        const SizedBox(height: 16),
        const Text('Cần quyền camera',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: openAppSettings,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB800)),
          child: const Text('Mở Cài đặt', style: TextStyle(color: Colors.black)),
        ),
      ]),
    ),
  );

  Widget _buildError() => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, color: Colors.white24, size: 48),
        const SizedBox(height: 16),
        const Text('Không mở được camera',
            style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _initCamera,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB800)),
          child: const Text('Thử lại', style: TextStyle(color: Colors.black)),
        ),
      ]),
    ),
  );
}