import 'package:driver/widgets/app_url_loouncher.dart';
import 'package:flutter/material.dart';

import '../utilitys/colors.dart';

class SIngleCarDetailsRow extends StatelessWidget {
  const SIngleCarDetailsRow({
    super.key, required this.title, required this.value, this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title: ",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.black
          ),
        ),
        InkWell(
          onTap: ()=>onTap,
          child: Text("$value",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.black
            ),
          ),
        ),
      ],
    );
  }
}
