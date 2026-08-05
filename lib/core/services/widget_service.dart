import 'package:home_widget/home_widget.dart';

class WidgetService {
  Future<String> getLatestPhoto() async {
    try {
      final value = await HomeWidget.getWidgetData<String>(
        'latest_photo',
        defaultValue: 'Ảnh mới nhất: Chuyến đi hè',
      );
      return value ?? 'Ảnh mới nhất: Chuyến đi hè';
    } catch (_) {
      return 'Ảnh mới nhất: Chuyến đi hè';
    }
  }

  Future<bool> refreshWidget() async {
    try {
      const nextValue = 'Ảnh mới nhất: Vừa cập nhật';
      await HomeWidget.saveWidgetData<String>('latest_photo', nextValue);
      await HomeWidget.saveWidgetData<String>(
          'latest_photo_title', 'Ảnh mới nhất');
      await HomeWidget.updateWidget(
        name: 'HomeWidgetProvider',
        iOSName: 'HomeWidget',
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
