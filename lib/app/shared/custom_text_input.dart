import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {

  final Color color;
  final String label;
  final double width;
  final int maxLength;
  final bool obscureText;
  final Color labelColor;
  final String placeholder;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final TextInputType inputType;
  final Function(String value) onChanged;
  final Function(String value) validator;
  final TextEditingController controller;
  final TextCapitalization capitalization;

  CustomTextInput({
    this.width,
    this.color,
    this.label,
    this.inputType,
    this.onChanged,
    this.validator,
    this.maxLength,
    this.textAlign,
    this.focusNode,
    this.labelColor,
    this.placeholder,
    this.capitalization,
    this.obscureText = false,
    @required this.controller,
  }): assert(controller != null);

  Widget _buildLabel(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          color: labelColor ?? Colors.black
        ),
      ),
    );
  }

  Widget _buildInputText(BuildContext context) {

    final BoxDecoration decoration = BoxDecoration(
      color: color ?? Colors.grey,
      borderRadius: BorderRadius.circular(999.0),
    );

    final TextFormField input = TextFormField(
      validator: validator,
      maxLength: maxLength,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: inputType ?? TextInputType.text,
      textCapitalization: capitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        hintText: placeholder,
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
          color: Colors.grey,
        ),
      ),
      onChanged: onChanged,
    );

    return Container(
      height: 48.0,
      child: input,
      decoration: decoration,
      padding: EdgeInsets.symmetric(horizontal: 20.0,),
      width: width ?? MediaQuery.of(context).size.width,
    );
  }

  Widget _buildInputField(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (label != null) ? _buildLabel(context) : SizedBox(), 
          (label != null) ? SizedBox(height: 7.5,) : SizedBox(),
          _buildInputText(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return _buildInputField(context);
  }
}