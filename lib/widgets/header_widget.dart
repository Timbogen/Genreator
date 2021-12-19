import 'package:flutter/material.dart';
import 'package:genreator/theme.dart';
import 'package:genreator/widgets/header_button_widget.dart';

class HeaderWidget extends StatefulWidget implements PreferredSizeWidget {
  /// The title
  final String title;

  /// Action buttons
  final List<HeaderButtonWidget>? actions;

  /// The callback if the title was edited
  final Function(String)? onEdit;

  /// Constructor
  const HeaderWidget({Key? key, required this.title, this.actions, this.onEdit}) : super(key: key);

  /// Initialize the state
  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();

  /// The preferred height of the app bar
  @override
  Size get preferredSize => const Size(double.infinity, 92);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  /// The controller for the name field
  final _textController = TextEditingController();

  /// True if the header is in edit mode
  var _editMode = false;

  /// The value of the edit field
  var _name = "";

  /// Set the initial value of name
  @override
  void initState() {
    super.initState();
    _name = widget.title;
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: paddingBig, top: 56, right: paddingBig, bottom: 16),
      child: Stack(
        children: [
          /// Title (or text field in edit mode)
          Positioned.fill(
            left: 48,
            right: 48,
            child: _editMode
                ? SizedBox(
                    height: 24,
                    child: TextField(
                      decoration:
                          const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      controller: _textController,
                      onChanged: (text) => _name = text,
                    ))
                : Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2,
                  ),
          ),

          /// The buttons
          Row(
            children: [
              /// Return button
              HeaderButtonWidget(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),

              /// The edit button
              Visibility(
                visible: widget.onEdit != null && !_editMode,
                child: HeaderButtonWidget(
                  icon: Icons.edit,
                  onPressed: () {
                    setState(() => _editMode = true);
                    _textController.text = widget.title;
                  },
                ),
              ),

              /// The confirm edit button
              Visibility(
                visible: _editMode,
                child: HeaderButtonWidget(
                  icon: Icons.check,
                  onPressed: () {
                    setState(() => _editMode = false);
                    widget.onEdit!(_name);
                  },
                ),
              ),

              /// Other (optional) action buttons
              Visibility(
                visible: !_editMode,
                child: Row(
                  children: [
                    ...widget.actions?.map((action) => Row(
                              children: [
                                const SizedBox(width: 16),
                                action,
                              ],
                            )) ??
                        []
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
