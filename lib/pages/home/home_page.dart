import 'package:first_app/entity/user_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/background.dart';
import 'components/home_icon_button.dart';
import 'home_controller.dart';
import 'home_provider.dart';
import '../../constants/constant_data.dart';
import 'components/user_card.dart';
import '../../components/all_navigation_bar.dart';
import '../../../entity/token_entity.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;
    final TokenEntity tokenEntity = arguments['token'] as TokenEntity;
    return HomePageProvider(
      tokenEntity: tokenEntity,
      child: Consumer<HomeController>(
        builder: (context, model, child) {
          return Scaffold(
            body: Stack(
              children: [
                Background(
                  showBackButton: false,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 200),
                            _buildPageView(model),
                            SizedBox(height: 150),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      _buildOptionsRow(model),
                      SizedBox(height: 20), // Space between options and buttons
                      _buildButtonRow(),
                    ],
                  ),
                ),
                AllNavigationBar(tokenEntity: tokenEntity),
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
      height: 40,
      color: Colors.transparent, // Adjust color as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildOption(model, ConstantData.honeyOption),
          ),
          SizedBox(width: 20), // Space between options
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
              top: 3, // Adjust as needed to move the image closer to the text
              right: 45, // Adjust as needed to position it to the right
              child: Image.asset(
                ConstantData.imagePathDecorate,
                width: 17,
                height: 17,
              ),
            ),
          Text(
            option,
            style: TextStyle(
              fontSize: 26,
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

  Widget _buildPageView(HomeController model) {
    return Container(
      height: 700, // Adjust the height as needed
      child: PageView(
        controller: model.pageController,
        onPageChanged: model.onPageChanged,
        children: [
          _buildUserListView(model),
          _buildUserListView(model),
        ],
      ),
    );
  }

  Widget _buildUserListView(HomeController model) {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          if (model.isLoading)
            CircularProgressIndicator()
          else if (model.errorMessage != null)
            Text('Error: ${model.errorMessage}')
          else
            ...model.users.map((user) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: UserCard(userEntity: user),
            )),
        ],
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HomeIconButton(
          imagePath: ConstantData.imagePathLike,
          shadowColor: Color(0xFFFFD1D1).withOpacity(0.3736),
          // labelText: 'Feel',
        ),
        HomeIconButton(
          imagePath: ConstantData.imagePathClock,
          shadowColor: Color(0xFFF6D3FF).withOpacity(0.369),
          // labelText: 'Get up',
        ),
        HomeIconButton(
          imagePath: ConstantData.imagePathGame,
          shadowColor: Color(0xFFFCA6C5).withOpacity(0.2741),
          // labelText: 'Game',
        ),
        HomeIconButton(
          imagePath: ConstantData.imagePathFeel,
          shadowColor: Color(0xFFFFEA31).withOpacity(0.3495),
          // labelText: 'Gossip',
        ),
        SizedBox(height: 100),
      ],
    );

  }
}
