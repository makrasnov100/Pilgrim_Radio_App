import 'package:flutter/material.dart';

class RadioSelector extends StatefulWidget {
  final Function(String) onChange;
  RadioSelector({Key key, this.onChange}) : super(key: key);

  @override
  _RadioSelectorState createState() => _RadioSelectorState();
}



class _RadioSelectorState extends State<RadioSelector> {
  String selected = "";
  
  void onChange(String value)
  {
    setState(() {
      selected = value;
    });


    if(widget.onChange != null)
      widget.onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Transform.scale(
          scale:.9,
          child: RadioListTile(
            title: const Text('Песни', style:TextStyle(fontSize: 15)),
            value: "Песни",
            groupValue: selected,
            onChanged: onChange,
          ),
        ),
        Transform.scale(
          scale:.9,
          child:RadioListTile(
          title: const Text('Стихи'),
          value: "Стихи",
          groupValue: selected,
          onChanged:  onChange,
        ),),
        Transform.scale(
          scale:.9,
          child:RadioListTile(
          title: const Text('Проповеди'),
          value: "Проповеди",
          groupValue: selected,
          onChanged:  onChange,
        ),),
        Transform.scale(
          scale:.9,
          child:RadioListTile(
          title: const Text('Мини проповеди'),
          value: "Мини проповеди",
          groupValue: selected,
          onChanged:  onChange,
        ),),
        Transform.scale(
          scale:.9,
          child:RadioListTile(
          title: const Text('Передачи с участием ведущих'),
          value: "Передачи с участием ведущих",
          groupValue: selected,
          onChanged:  onChange,
        ),),
        Transform.scale(
          scale:.9,
          child:RadioListTile(
          title: const Text('Беседы со служителями и пастырями'),
          value: "Беседы со служителями и пастырями",
          groupValue: selected,
          onChanged:  onChange,
        ),),
      ],
    );
  }
}