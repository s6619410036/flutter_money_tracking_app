import 'package:flutter/material.dart';
import 'package:flutter_money_tracking_app/views/money_balance_ui.dart';
import 'package:flutter_money_tracking_app/views/money_in_ui.dart';
import 'package:flutter_money_tracking_app/views/money_out_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int _selectedIndex = 1; // เริ่มที่หน้าสรุปยอด (หน้ากลาง)

  final List<Widget> _pages = const [
    MoneyInUI(),
    MoneyBalanceUI(),
    MoneyOutUI(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้ IndexedStack เพื่อรักษา State ของหน้าแต่ละหน้าไว้ไม่ให้โหลดใหม่
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // ปรับแต่งสีตามดีไซน์ต้นฉบับ
        backgroundColor: const Color.fromARGB(255, 19, 109, 97), // สีเขียว Teal
        selectedItemColor: Colors.white, // ไอคอนที่เลือกเป็นสีขาว
        unselectedItemColor: Colors.white60, // ไอคอนที่ไม่เลือกเป็นสีขาวจาง
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 15,
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(
              Icons.account_balance_wallet_rounded,
              0,
              const Color(
                0xFFE5FF00,
              ), // สีเหลืองสะท้อนแสงเวลาเลือก (ตามสีเครดิตหน้า Splash)
            ),
            label: 'เงินเข้า',
          ),
          BottomNavigationBarItem(
            icon: _buildNotebookIcon(1),
            label: 'สรุปยอด',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              Icons.monetization_on_rounded,
              2,
              const Color(0xFFE5FF00),
            ),
            label: 'เงินออก',
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างไอคอนพร้อมอนิเมชั่นขยับขึ้น
  Widget _buildIcon(IconData icon, int index, Color activeColor) {
    final isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, isSelected ? -8 : 0, 0),
      child: Icon(
        icon,
        size: isSelected ? 32 : 26,
        color: isSelected ? activeColor : Colors.white60,
      ),
    );
  }

  // ฟังก์ชันสร้างไอคอนสมุด (หน้ากลาง)
  Widget _buildNotebookIcon(int index) {
    final isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, isSelected ? -12 : 0, 0),
      child: Icon(
        Icons.menu_book_rounded,
        size: isSelected ? 38 : 30,
        color: isSelected ? Colors.white : Colors.white60,
      ),
    );
  }
}
