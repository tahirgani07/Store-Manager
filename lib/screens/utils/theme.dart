import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_manager/screens/utils/marquee_widget.dart';

TextStyle listTileDefaultTextStyle = TextStyle(
    color: Colors.white70, fontSize: 15.0, fontWeight: FontWeight.w600);
TextStyle listTileSelectedTextStyle =
    TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600);

Color selectedColor = Color(0xFF4AC8EA);
Color drawerBgColor = Color(0xFF272D34);

// Collapsing Navigation Drawer
double navMaxWidth = 200;
double navMinWidth = 70;
double desktopWidth = 1000;
double naveSizeToHideText = 180;

//-------------Billing Scren-------------
double numWidth = 45;
double itemWidth = 675;
double qtyWidth = 112;
double unitWidth = 112;
double pricePerUnitWidth = 140;
double discountWidth = 140;
double taxWidth = 180;
double amountWidth = 112;

//------------------------------------
Color bgColor = Color(0xffE4E8EF);

extension StringExtension on String {
  String get inCaps =>
      '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}

Widget customTextField({
  String label,
  TextEditingController controller,
  int maxLines = 1,
  bool autofocus = false,
  bool readOnly = false,
  Function onTap,
  bool numeric = false,
  String name = "",
}) {
  return Container(
    margin: EdgeInsets.all(10.0),
    child: TextField(
      readOnly: readOnly,
      onTap: onTap,
      autofocus: autofocus,
      controller: controller,
      inputFormatters: (numeric)
          ? <TextInputFormatter>[
              DecimalTextInputFormatter(decimalRange: 5),
            ]
          : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        isDense: true,
        alignLabelWithHint: true,
      ),
      maxLines: maxLines,
    ),
  );
}

Widget alertActionButton({
  @required BuildContext context,
  String title,
  Color color,
  Function onPressed,
}) {
  return RaisedButton(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    color: color ?? Colors.red,
    child: Text(title ?? "Close"),
    onPressed: onPressed ?? () => Navigator.of(context).pop(),
  );
}

Widget getSearchBar(
    TextEditingController searchController, Function onSearchTextChanged) {
  return Container(
    color: Colors.grey,
    child: new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          dense: true,
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: searchController,
            decoration: new InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              isDense: true,
            ),
            onChanged: onSearchTextChanged,
          ),
          trailing: (searchController.text.isEmpty)
              ? null
              : new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed: () {
                    searchController.clear();
                    onSearchTextChanged('');
                  },
                ),
        ),
      ),
    ),
  );
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({@required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(RegExp(r'[!--]')) ||
        value.contains(RegExp(r'[:-~]')) ||
        value.contains('/')) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }
    if (oldValue.text.contains('.') &&
        value.substring(value.indexOf(".") + 1).contains('.')) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }
    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: min(truncated.length, truncated.length + 1),
        extentOffset: min(truncated.length, truncated.length + 1),
      );
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

Widget getFlexContainer(
  String title,
  int flex, {
  bool border = true,
  color,
  double height = 50,
  //height should be 57 for heading row
  Alignment alignment = Alignment.centerLeft,
  bool textBold = false,
  bool greyText = false,
  String tooltipMsg = "",
}) {
  return Flexible(
    flex: flex,
    child: Container(
      height: height,
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        border: border ? Border.all(color: Colors.grey) : null,
        color: color,
      ),
      child: MarqueeWidget(
        child: Text(
          title,
          style: TextStyle(
              color: greyText ? Colors.grey.shade600 : null,
              fontWeight: textBold ? FontWeight.w500 : null),
        ),
      ),
    ),
  );
}