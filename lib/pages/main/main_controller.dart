import 'package:get/get.dart';
import 'package:first_app/entity/token_entity.dart';
import 'package:first_app/entity/user_data_entity.dart';

class MainController extends GetxController {
  final TokenEntity tokenEntity;
  final UserDataEntity? userData;

  final _currentRoute = '/home'.obs;
  String get currentRoute => _currentRoute.value;

  MainController({required this.tokenEntity, this.userData});

  void changePage(String route) {
    if (_currentRoute.value != route) {
      _currentRoute.value = route;
      Get.toNamed(route, id: 1); // 使用嵌套导航
    }
  }

  String get currentPageTitle {
    switch (_currentRoute.value) {
      case '/home':
        return 'Home';
      case '/moments':
        return 'Moments';
      case '/message':
        return 'Messages';
      case '/me':
        return 'Profile';
      default:
        return 'Home';
    }
  }

  // 检查给定路由是否为当前路由
  bool isCurrentRoute(String route) {
    return _currentRoute.value == route;
  }

  // 可以添加其他需要的方法，比如处理通知、更新用户数据等

  @override
  void onInit() {
    super.onInit();
    // 在这里可以进行一些初始化操作
    // 例如，获取用户数据、设置初始状态等
  }

  @override
  void onClose() {
    // 在控制器被销毁时进行清理
    super.onClose();
  }
}