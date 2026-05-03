import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/money_model.dart';
import '../../services/supabase_services.dart';

class MoneyInUI extends StatefulWidget {
  const MoneyInUI({super.key});

  @override
  State<MoneyInUI> createState() => _MoneyInUIState();
}

class _MoneyInUIState extends State<MoneyInUI> {
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();

  // กำหนดฟอร์แมตวันที่แบบไทย
  String formattedDate = DateFormat.yMMMMd('th').format(DateTime.now());

  void showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Kanit')),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveMoneyIn() async {
    if (_detailController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty) {
      showMessage('กรุณากรอกข้อมูลให้ครบถ้วน!', Colors.orange);
      return;
    }

    try {
      final moneyData = MoneyModel(
        title: _detailController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        type: 'in',
        transactionDate: DateTime.now().toIso8601String(),
      );

      await _supabaseService.insertTransaction(moneyData);

      showMessage('บันทึกข้อมูลรายรับเรียบร้อยแล้ว', Colors.green);

      _detailController.clear();
      _amountController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      showMessage('เกิดข้อผิดพลาด: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header แสดงยอดเงินแบบ Real-time ---
            StreamBuilder<List<MoneyModel>>(
              stream: _supabaseService.getTransactionStream(),
              builder: (context, snapshot) {
                double balance = 0;
                if (snapshot.hasData) {
                  double totalIn = 0;
                  double totalOut = 0;
                  for (var item in snapshot.data!) {
                    if (item.type == 'in') {
                      totalIn += item.amount;
                    } else {
                      totalOut += item.amount;
                    }
                  }
                  balance = totalIn - totalOut;
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(25, 50, 25, 30),
                  decoration: const BoxDecoration(
                    color: const Color.fromARGB(255, 19, 109, 97),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // แก้ไข: ใส่รูปโปรไฟล์จาก Assets ให้ระบุเป็น child หรือ backgroundImage อย่างถูกต้อง
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                const AssetImage('assets/images/mabell.jpg'),
                            // ถ้าโหลดรูปไม่ขึ้นจะแสดง Icon พื้นฐาน
                            onBackgroundImageError: (error, stackTrace) {},
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Pimpikun Butprom',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Text('ยอดเงินคงเหลือ',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 5),
                      Text(
                        NumberFormat('#,###.00').format(balance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 35),
            Text(
              'วันที่ $formattedDate',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'เงินเข้า',
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 30),

            // --- ฟอร์มกรอกข้อมูล ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    controller: _detailController,
                    decoration: InputDecoration(
                      labelText: 'รายการเงินเข้า',
                      hintText: 'เช่น เงินเดือน, ขายของ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF4D968E), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'จำนวนเงินเข้า',
                      hintText: '0.00',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF4D968E), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _saveMoneyIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D968E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 3,
                      ),
                      child: const Text(
                        'บันทึกเงินเข้า',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
