import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final IconData? trailingIcon;
  final Color? color;
  final Function()? onPress;

  const CustomContainer({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.trailingIcon,
    this.color,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress!();
      },
      child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      leadingIcon,
                      color: color != null ? color : Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color != null ? color : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingIcon != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    trailingIcon,
                    color: Colors.white,
                    size: 30,
                  ),
                )
            ],
          )),
    );
  }
}
