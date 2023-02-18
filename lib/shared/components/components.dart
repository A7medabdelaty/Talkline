import 'package:flutter/material.dart';
Widget mySeparatorBuilder({double startSpace = 0}) => Padding(
      padding: EdgeInsetsDirectional.only(
        start: startSpace,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget defaultInputField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  var onSubmit,
  required String label,
  var onChange,
  IconData? prefixIcon,
  IconData? suffixIcon,
  var onTap,
  bool readOnly = false,
  validator,
  var suffixAction,
  bool obscureText = false,
}) =>
    TextFormField(
      onChanged: onChange,
      onTap: onTap,
      readOnly: readOnly,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmit,
      obscureText: obscureText ? true : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
            onPressed: suffixAction,
            icon: Icon(
              suffixIcon,
            )),
        border: const OutlineInputBorder(),
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  required String text,
  Color color = Colors.blue,
  var onPressed,
  double radius = 4.0,
}) =>
    Container(
        height: 40.0,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
        ),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ));

void navigateTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndReplace(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}
