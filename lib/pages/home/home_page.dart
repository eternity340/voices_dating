import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart' as getx;
import '../../components/background.dart';
import 'components/home_icon_button.dart';
import 'home_controller.dart';
import 'home_provider.dart';
import '../../constants/constant_data.dart';
import 'components/user_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = getx.Get.arguments as Map<String, dynamic>;
    final String token = arguments['token'];

    return HomePageProvider(
      token: token,
      child: Consumer<HomeController>(
        builder: (context, model, child) {
          return Scaffold(
            body: Background(
              showBackButton: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 71,
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
                        ),
                        Container(
                          height: 1000, // Adjust the height as needed
                          child: PageView(
                            controller: model.pageController,
                            onPageChanged: model.onPageChanged,
                            children: [
                              ListView(
                                children: [
                                  _buildButtonRow(),
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
                              Center(child: Text(ConstantData.nearbyPageContent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
              top: 0, // Adjust as needed to move the image closer to the text
              right: 40, // Adjust as needed to position it to the right
              child: Image.asset(
                ConstantData.imagePathDecorate,
                width: 17,
                height: 17,
              ),
            ),
          Text(
            option,
            style: TextStyle(
              fontSize: 28,
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

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HomeIconButton(imagePath: ConstantData.imagePathLike, shadowColor: Color(0xFFFFD1D1).withOpacity(0.3736)),
        HomeIconButton(imagePath: ConstantData.imagePathClock, shadowColor: Color(0xFFF6D3FF).withOpacity(0.369)),
        HomeIconButton(imagePath: ConstantData.imagePathGame, shadowColor: Color(0xFFFCA6C5).withOpacity(0.2741)),
        HomeIconButton(imagePath: ConstantData.imagePathFeel, shadowColor: Color(0xFFFFEA31).withOpacity(0.3495)),
      ],
    );
  }
}
