import 'package:flutter/material.dart';
import '../../helpers/utils.dart';

class DropDown extends StatefulWidget {
  @required
  Function? onChanged;
  @required
  List<Map>? items;
  String? label;
  double? width;
  DropDown({Key? key, required this.onChanged, required this.items, this.label,this.width})
      : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      // width: MediaQuery.of(context).size.width * 0.35,
      width: widget.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
          // borderRadius: BorderRadius.circular(10),
          value: _chosenValue,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
          items: widget.items?.map<DropdownMenuItem<String>>((Map item) {
            return DropdownMenuItem<String>(
              value: item["value"].toString(),
              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    item.containsKey("logo")
                        ? networkImage(
                            item["logo"],
                            20,
                            20,
                          )
                        : Container(),
                    Flexible(
                      child: Text(
                        item["text"].toString(),
                        overflow: TextOverflow.ellipsis,
                        style:TextStyle(
                        color: Theme.of(context).accentColor,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Text(
              widget.label!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          onChanged: (value) {
            widget.onChanged!(value);
          },
        ),
      ),
    );
  }
}
