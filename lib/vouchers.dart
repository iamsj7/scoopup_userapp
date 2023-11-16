import 'package:flutter/material.dart';

class vouchers extends StatefulWidget {
  const vouchers({super.key});

  @override
  State<vouchers> createState() => _vouchersState();
}

class _vouchersState extends State<vouchers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
        backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(0xFFCE4141)),
          title: Padding(
            padding: const EdgeInsets.only(left:90),
            child: const Text(
              'Vouchers',
              style: TextStyle(
                color: Color(0xFFCE4141),
                fontSize: 26,
                fontFamily: "Nunito Sans",
                fontWeight: FontWeight.w600,
                
              ),
            ),
          ),
      ),);
  }
}