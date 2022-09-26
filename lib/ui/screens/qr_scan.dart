import 'package:admin/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  // @override
  // void initState() {
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Navigator.of(context).pop("umTZsDdIfsfZAb678aPgCv1CW7P2");
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScanView(
      scanLineColor: AppColors.brown2,
      onCapture: (v) => Navigator.of(context).pop(v),
    ));
  }
}
