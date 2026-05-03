// ignore_for_file: unnecessary_null_comparison

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/money_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // 1. ฟังก์ชันบันทึกข้อมูล
  Future<void> insertTransaction(MoneyModel money) async {
    try {
      // ใช้ toMap() ที่เราเตรียมไว้ใน Model เพื่อส่งค่า id, title, amount, type, transaction_date
      await _supabase.from('money_tb').insert(money.toMap());
    } catch (e) {
      print('Insert Error: $e');
      throw Exception('ไม่สามารถบันทึกข้อมูลได้: $e');
    }
  }

  // 2. ฟังก์ชันดึงข้อมูลแบบ Real-time Stream
  // จุดนี้คือหัวใจที่ทำให้ทุกหน้าซิงค์กัน เพราะเมื่อ DB เปลี่ยน ทุกหน้าจะรู้ทันที
  Stream<List<MoneyModel>> getTransactionStream() {
    return _supabase
        .from('money_tb')
        .stream(primaryKey: ['id']) // ใช้ 'id' ตามโครงสร้างตาราง
        .order('transaction_date', ascending: false)
        .map((data) {
          // แปลงข้อมูลจาก List<Map> เป็น List<MoneyModel>
          return data.map((map) => MoneyModel.fromMap(map)).toList();
        });
  }

  // 3. ฟังก์ชันดึงข้อมูลสรุปยอด (ใช้ Future สำหรับเรียกครั้งเดียว)
  Future<Map<String, double>> getSummary() async {
    try {
      final response = await _supabase.from('money_tb').select('amount, type');

      double totalIn = 0;
      double totalOut = 0;

      if (response != null) {
        for (var item in response) {
          double amt = (item['amount'] as num?)?.toDouble() ?? 0.0;
          if (item['type'] == 'in') {
            totalIn += amt;
          } else if (item['type'] == 'out') {
            totalOut += amt;
          }
        }
      }

      return {
        'totalIn': totalIn,
        'totalOut': totalOut,
        'balance': totalIn - totalOut,
      };
    } catch (e) {
      print('Summary Error: $e');
      return {'totalIn': 0, 'totalOut': 0, 'balance': 0};
    }
  }
}
