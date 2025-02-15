import '../ui/base/libraryExport.dart';

enum GroupedButtonsOrientation {
  HORIZONTAL,
  VERTICAL,
}

class RadioButtonGroup extends StatefulWidget {
  /// A list of strings that describes each Radio button. Each label must be distinct.
  final List<Bank> labels;

  /// Specifies which Radio button to automatically pick.
  /// Every element must match a label.
  /// This is useful for clearing what is picked (set it to "").
  /// If this is non-null, then the user must handle updating this; otherwise, the state of the RadioButtonGroup won't change.
  final Bank picked;

  /// Specifies which buttons should be disabled.
  /// If this is non-null, no buttons will be disabled.
  /// The strings passed to this must match the labels.
  final List<String> disabled;

  /// Called when the value of the RadioButtonGroup changes.
  final void Function(Bank label, int index) onChange;

  /// Called when the user makes a selection.
  final void Function(Bank selected) onSelected;

  /// The style to use for the labels.
  final TextStyle labelStyle;

  /// Specifies the orientation to display elements.
  final GroupedButtonsOrientation orientation;

  /// Called when needed to build a RadioButtonGroup element.
  final Widget Function(Radio radioButton, Bank label, int index) itemBuilder;

  //RADIO BUTTON FIELDS
  /// The color to use when a Radio button is checked.
  final Color activeColor;

  //SPACING STUFF
  /// Empty space in which to inset the RadioButtonGroup.
  final EdgeInsetsGeometry padding;

  /// Empty space surrounding the RadioButtonGroup.
  final EdgeInsetsGeometry margin;

  RadioButtonGroup({
    Key key,
    @required this.labels,
    this.picked,
    this.disabled,
    this.onChange,
    this.onSelected,
    this.labelStyle = const TextStyle(),
    this.activeColor, //defaults to toggleableActiveColor,
    this.orientation = GroupedButtonsOrientation.VERTICAL,
    this.itemBuilder,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  _RadioButtonGroupState createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  Bank _selected;

  @override
  void initState() {
    super.initState();

    //set the selected to the picked (if not null)
    _selected = widget.picked ?? Bank();
  }

  @override
  Widget build(BuildContext context) {
    //set the selected to the picked (if not null)
    _selected = widget.picked ?? _selected;

    List<Widget> content = [];
    for (int i = 0; i < widget.labels.length; i++) {
      Radio rb = Radio(
        activeColor:
            widget.activeColor ?? Theme.of(context).toggleableActiveColor,
        groupValue: widget.labels.indexOf(_selected),
        value: i,

        //just changed the selected filter to current selection
        //since these are radio buttons, and you can only pick
        //one at a time
        onChanged: (widget.disabled != null &&
                widget.disabled.contains(widget.labels.elementAt(i)))
            ? null
            : (var index) => setState(() {
                  _selected = widget.labels.elementAt(i);

                  if (widget.onChange != null)
                    widget.onChange(widget.labels.elementAt(i), i);
                  if (widget.onSelected != null)
                    widget.onSelected(widget.labels.elementAt(i));
                }),
      );

      Bank t = widget.labels.elementAt(i);

      //use user defined method to build
      if (widget.itemBuilder != null)
        content.add(widget.itemBuilder(rb, t, i));
      else {
        //otherwise, use predefined method of building

        //vertical orientation means Column with Row inside
        if (widget.orientation == GroupedButtonsOrientation.VERTICAL) {
          content.add(Row(children: <Widget>[
            SizedBox(width: 12.0),
            rb,
            SizedBox(width: 12.0),
          ]));
        } else {
          //horizontal orientation means Row with Column inside

          content.add(Column(children: <Widget>[
            rb,
            SizedBox(width: 12.0),
          ]));
        }
      }
    }

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: widget.orientation == GroupedButtonsOrientation.VERTICAL
          ? Column(children: content)
          : Row(children: content),
    );
  }
}
