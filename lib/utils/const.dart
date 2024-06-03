import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';

class Constants {
  //Desing Color

  static Color secondarycolor = Color(0xFFBCECE0); // Paired with cyan
  static Color primarycolor = Color(0xFF4C5270); // Paired with bluemunsell
  static Color bluemunsell = Color(0xFF62929E); // Paired with primarycolor
  static Color backgroundColor = Color.fromRGBO(245, 245, 247, 1);
  static Color symptomschart = Color(0xFF129490);
  static Color intensitychart = Color(0xFFcb4154);
}

//Profile Menu at Profile_page
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.textColor,
    this.endIcon = true,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Constants.secondarycolor.withOpacity(0.8),
        ),
        child: Icon(icon, color: Constants.primarycolor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Constants.primarycolor.withOpacity(0.1),
              ),
              child: Icon(LineIcons.angleRight, color: Constants.primarycolor),
            )
          : null,
    );
  }
}
