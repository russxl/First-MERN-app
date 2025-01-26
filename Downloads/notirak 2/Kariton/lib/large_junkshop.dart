import 'package:flutter/material.dart';
import 'booking_page.dart';
import 'news_page.dart';
import 'profile_page.dart';

class LargeJunkshopScreen extends StatefulWidget {
  final Map<String, dynamic> userData; // This should include 'name', 'points', and 'goods' data

  const LargeJunkshopScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _LargeJunkshopScreenState createState() => _LargeJunkshopScreenState();
}

class _LargeJunkshopScreenState extends State<LargeJunkshopScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              if (_selectedIndex == 0) ...[
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 16),
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/img1.png'),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: <Widget>[
                    ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: <Widget>[
                        Text(
                          'Junkshop you added:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              _buildJunkshopCard('assets/profile1.png', 'Dasig Junkshop', 'Manila'),
                              _buildJunkshopCard('assets/profile2.png', 'Napa Junkshop', 'Mandaluyong'),
                              _buildJunkshopCard('assets/profile3.png', 'Russell Junkshop', 'Quezon City'),
                              _buildAddButton(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Fact: About 2.01 billion tons of municipal solid waste is generated globally each year.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          'Scrap Collection',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              _buildCategoryBox('assets/plastic.png', 'Plastic'),
                              _buildCategoryBox('assets/copper.png', 'Copper'),
                              _buildCategoryBox('assets/steel.png', 'Steel'),
                              _buildCategoryBox('assets/karton.png', 'Karton'),
                              _buildCategoryBox('assets/paper.png', 'Paper'),
                              _buildCategoryBox('assets/yero.png', 'Yero'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const BookingPage(),
                    const NewsPage(),
                    ProfilePage(userData: widget.userData), // Fix reference to widget.userData
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF40A858),
        selectedLabelStyle: TextStyle(color: Colors.grey),
        unselectedLabelStyle: TextStyle(color: Colors.white),
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
      ),
    );
  }

  Widget _buildJunkshopCard(String imagePath, String name, String location) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 50,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            location,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Column(
      children: [
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            print('Add button pressed');
          },
          child: const Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCategoryBox(String imagePath, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
