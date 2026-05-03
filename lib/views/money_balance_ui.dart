import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/money_model.dart';
import '../../services/supabase_services.dart';

class MoneyBalanceUI extends StatefulWidget {
  const MoneyBalanceUI({super.key});

  @override
  State<MoneyBalanceUI> createState() => _MoneyBalanceUIState();
}

class _MoneyBalanceUIState extends State<MoneyBalanceUI> {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFFF8F9FA), // ปรับพื้นหลังให้อ่อนลงเล็กน้อยเพื่อให้ Card เด่นขึ้น
      body: StreamBuilder<List<MoneyModel>>(
        stream: _supabaseService.getTransactionStream(),
        builder: (context, snapshot) {
          // 1. ระหว่างรอข้อมูล (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    color: const Color.fromARGB(255, 19, 109, 97)));
          }

          // 2. กรณีเกิดข้อผิดพลาด
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          // 3. กรณีไม่มีข้อมูล
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final transactions = snapshot.data!;

          // คำนวณยอดรวม Real-time
          double totalIn = 0;
          double totalOut = 0;
          for (var item in transactions) {
            if (item.type == 'in') {
              totalIn += item.amount;
            } else {
              totalOut += item.amount;
            }
          }
          double balance = totalIn - totalOut;

          return Column(
            children: [
              // --- Header ส่วนสรุปยอด ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
                decoration: const BoxDecoration(
                  color: const Color.fromARGB(255, 19, 109, 97),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // แก้ไข: ส่วนรูปโปรไฟล์ - เปลี่ยนเป็น AssetImage
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white30,
                            // * แก้ไขตรงนี้ *
                            backgroundImage: AssetImage(
                              'assets/images/mabell.jpg', // ตรวจสอบเส้นทางโฟลเดอร์ให้ตรงกับที่ลงทะเบียนใน pubspec.yaml
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Pimpikun Butprom',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'ยอดเงินคงเหลือ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      NumberFormat('#,###.00').format(balance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryItem(Icons.arrow_downward, 'ยอดรายรับ',
                            totalIn, Colors.greenAccent),
                        _buildSummaryItem(Icons.arrow_upward, 'ยอดรายจ่าย',
                            totalOut, Colors.orangeAccent),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.history, size: 22, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(
                      'รายการเดินบัญชี',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // --- รายการ Transaction ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final item = transactions[index];
                    bool isIncome = item.type == 'in';
                    DateTime date = DateTime.parse(item.transactionDate);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isIncome
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isIncome
                                  ? Icons.add_rounded
                                  : Icons.remove_rounded,
                              color: isIncome ? Colors.green : Colors.red,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF444444),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('d Apr 2026 - HH:mm').format(date),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${isIncome ? "+" : "-"} ${NumberFormat('#,###.00').format(item.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // ส่วน Bottom Navigation เลียนแบบในรูป
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF4D968E),
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // เลือกหน้าสรุปยอด
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'เงินเข้า'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: 'สรุปยอด'),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), label: 'เงินออก'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text('ยังไม่มีรายการบันทึก',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      IconData icon, String label, double amount, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Text(
                NumberFormat('#,###.00').format(amount),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
