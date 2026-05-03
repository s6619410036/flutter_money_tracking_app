import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_money_tracking_app/views/welcome_ui.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // หน่วงเวลา 3 วินาทีก่อนไปหน้า WelcomeUI
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomeUI()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 56, 50), // สีเขียว Teal ตามรูป
      body: Stack(
        children: [
          // องค์ประกอบหลักตรงกลาง (รูปภาพ + ชื่อแอป)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // * เพิ่มรูปภาพตรงนี้ *
                Image.asset(
                  'assets/images/welcome.png', // ชื่อไฟล์ภาพที่คุณเตรียมไว้
                  height: 300, // กำหนดความสูงตามความเหมาะสม
                  fit: BoxFit.contain, // ให้รูปภาพรักษาอัตราส่วน
                ),

                SizedBox(height: 30), // เพิ่มระยะห่างระหว่างรูปภาพและชื่อแอป

                // ชื่อแอปภาษาอังกฤษ
                Text(
                  'Money Tracking',
                  style: TextStyle(
                    fontSize: 28, // ปรับขนาดให้พอดี
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                // ชื่อแอปภาษาไทย
                Text(
                  'รายรับรายจ่ายของฉัน',
                  style: TextStyle(
                    fontSize: 16, // ปรับขนาดให้พอดี
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // ข้อความเครดิตด้านล่าง (ยังคงเดิม)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Created by 6619410036',
                  style: TextStyle(
                    color: Color(0xFFE5FF00), // สีเหลืองตามรูป
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '- SAU -',
                  style: TextStyle(
                    color: Color(0xFFE5FF00),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
