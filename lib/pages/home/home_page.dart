import 'package:flutter/material.dart';
import '../../components/background.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedOption = 'Honey';
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectOption(String option) {
    setState(() {
      selectedOption = option;
      if (option == 'Honey') {
        _pageController.animateToPage(0,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      } else {
        _pageController.animateToPage(1,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedOption = index == 0 ? 'Honey' : 'Nearby';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        showBackButton: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 71,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildOption('Honey'),
                      SizedBox(width: 50), // Space between options
                      _buildOption('Nearby'),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  height: 200, // Example height constraint for PageView
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButtonRow(),
                          SizedBox(height: 20),
                          _buildHoneyPageContent(),
                        ],
                      ),
                      Center(child: Text('Nearby Page Content')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    bool isSelected = selectedOption == option;
    return GestureDetector(
      onTap: () => _selectOption(option),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Positioned(
              top: 0, // Adjusted to bring closer to text
              right: 0, // Adjusted to bring closer to text
              child: Image.asset(
                'assets/images/decorate.png',
                width: 17,
                height: 17,
              ),
            ),
          Text(
            option,
            style: TextStyle(
              fontSize: 24,
              height: 22 / 18,
              // Line height in terms of font size
              letterSpacing: -0.011249999515712261,
              fontFamily: 'Open Sans',
              color: isSelected ? Color(0xFF000000) : Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoneyPageContent() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Honey Page Content'),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0, // Space between buttons
      children: [
        _buildButton('assets/images/icon_like.png', Color(0xFFFFD1D1).withOpacity(0.3736)),
        _buildButton('assets/images/icon_clock.png', Color(0xFFF6D3FF).withOpacity(0.369)),
        _buildButton('assets/images/icon_game.png', Color(0xFFFCA6C5).withOpacity(0.2741)),
        _buildButton('assets/images/icon_feel.png', Color(0xFFFFEA31).withOpacity(0.3495)),
      ],
    );
  }

  Widget _buildButton(String imagePath, Color shadowColor) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0, 7),
            blurRadius: 15,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(imagePath),
      ),
    );
  }
}
