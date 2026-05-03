// ignore_for_file: unused_import

import 'dart:convert';

class MoneyModel {
  final int? id;
  final String? createdAt;
  final String title;
  final double amount;
  final String type; // 'in' สำหรับเงินเข้า, 'out' สำหรับเงินออก
  final String transactionDate;

  MoneyModel({
    this.id,
    this.createdAt,
    required this.title,
    required this.amount,
    required this.type,
    required this.transactionDate,
  });

  // 1. แปลงข้อมูลจาก Map (ที่ได้จาก Supabase) มาเป็น Model Object
  factory MoneyModel.fromMap(Map<String, dynamic> map) {
    return MoneyModel(
      // ตรวจสอบชื่อ Key ให้ตรงกับ Column ในตาราง money_tb เป๊ะๆ
      id: map['id'] as int?,
      createdAt: map['created_at'] as String?,
      title: map['title'] ?? '',
      // แปลงค่าจาก num เป็น double เพื่อรองรับ float8 ใน Database
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      type: map['type'] ?? '',
      transactionDate: map['transaction_date'] ?? '',
    );
  }

  // 2. แปลงจาก Model Object กลับเป็น Map เพื่อส่งไปบันทึกใน Supabase
  Map<String, dynamic> toMap() {
    return {
      // ใช้ชื่อ Key ให้ตรงกับคอลัมน์ในฐานข้อมูล (title, amount, type, transaction_date)
      'title': title,
      'amount': amount,
      'type': type,
      'transaction_date': transactionDate,
    };
  }
}
