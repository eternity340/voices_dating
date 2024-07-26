import 'package:flutter/cupertino.dart'; // 引入 Cupertino 库
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import '../../constants/constant_data.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';
import '../../image_res/image_res.dart';
import 'components/home_icon_button.dart';
import 'components/user_card.dart';
import 'home_controller.dart';
import 'home_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _opacity = 0.0;
  bool _isTop = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // Delay to trigger the animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
        _isTop = false;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    // Implement your load more function here
    // For example, call your API to fetch more data
    print("Load more data");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;
    final TokenEntity tokenEntity = arguments['token'] as TokenEntity;
    final UserDataEntity userData = arguments['userData'] as UserDataEntity;

    return HomePageProvider(
      tokenEntity: tokenEntity,
      userData: userData,
      child: Consumer<HomeController>(
        builder: (context, model, child) {
          return Scaffold(
            body: Stack(
              children: [
                Background(
                  showBackButton: false,
                  child: Container(),
                ),
                Positioned(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.sp),
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        _buildOptionsRow(model),
                        _buildButtonRow(),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: _buildAnimatedPageView(model),
                        ),
                      ],
                    ),
                  ),
                ),
                AllNavigationBar(tokenEntity: tokenEntity, userData: userData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionsRow(HomeController model) {
    return Container(
      width: double.infinity,
      height: 40.h,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildOption(model, ConstantData.honeyOption),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: _buildOption(model, ConstantData.nearbyOption),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(HomeController model, String option) {
    bool isSelected = model.selectedOption == option;
    return GestureDetector(
      onTap: () => model.selectOption(option),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Positioned(
              top: 3,
              right: 45.w,
              child: Image.asset(
                ImageRes.imagePathDecorate,
                width: 17.w,
                height: 17.h,
              ),
            ),
          Text(
            option,
            style: TextStyle(
              fontSize: 26.sp,
              height: 22 / 18,
              letterSpacing: -0.011249999515712261,
              fontFamily: 'Open Sans',
              color: isSelected ? Color(0xFF000000) : Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedPageView(HomeController model) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(seconds: 1),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: _isTop ? 50.h : 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildPageView(model),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(HomeController model) {
    return PageView(
      controller: model.pageController,
      onPageChanged: model.onPageChanged,
      children: [
        _buildUserListView(model),
        Container(
          child: Center(child: Text('Nearby Page')),
        ), // Add your Nearby page widget here
      ],
    );
  }

  Widget _buildUserListView(HomeController model) {
    return ListView(
      controller: _scrollController,
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        if (model.isLoading)
          Center(child: CupertinoActivityIndicator()) // iOS样式的加载指示器
        else if (model.errorMessage != null)
          Center(child: Text('Error: ${model.errorMessage}'))
        else
          ...model.users.map((user) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: UserCard(userEntity: user,),
          )),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathLike,
          shadowColor: Color(0xFFFFD1D1).withOpacity(0.3736),
          label: 'Feel',
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathClock,
          shadowColor: Color(0xFFF6D3FF).withOpacity(0.369),
          label: 'Get up',
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathGame,
          shadowColor: Color(0xFFFCA6C5).withOpacity(0.2741),
          label: 'Game',
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathFeel,
          shadowColor: Color(0xFFFFEA31).withOpacity(0.3495),
          label: 'Gossip',
        ),
      ],
    );
  }

  Widget _buildButtonWithLabel({
    required String imagePath,
    required Color shadowColor,
    required String label,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeIconButton(
            imagePath: imagePath,
            shadowColor: shadowColor,
          ),
          SizedBox(height: 4.h), // 调整这个值来向上移动文字
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 14.sp,
              height: 22 / 14,
              letterSpacing: -0.00875,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
