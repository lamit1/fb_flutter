import 'package:fb_app/core/pallete.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CommentBox extends StatefulWidget {
  Widget? child;
  dynamic formKey;
  dynamic sendButtonMethod;
  dynamic commentController;
  ImageProvider? userImage;
  String? labelText;
  String? errorText;
  Widget? sendWidget;
  Color? backgroundColor;
  Color? textColor;
  bool withBorder;
  Widget? header;
  FocusNode? focusNode;
  Function? setType;
  String? currentMarkType;
  CommentBox(
      {this.child,
        this.header,
        this.sendButtonMethod,
        this.formKey,
        this.commentController,
        this.sendWidget,
        this.userImage,
        this.labelText,
        this.focusNode,
        this.errorText,
        this.withBorder = true,
        this.backgroundColor,
        this.setType,
        this.textColor,
        this.currentMarkType});

  @override
  State<CommentBox> createState() => _CommentBoxState();

  /// This method is used to parse the image from the URL or the path.
  /// `CommentBox.commentImageParser(imageURLorPath: 'url_or_path_to_image')`
  static ImageProvider commentImageParser({imageURLorPath}) {
    try {
      //check if imageURLorPath
      if (imageURLorPath is String) {
        if (imageURLorPath.startsWith('http')) {
          return NetworkImage(imageURLorPath);
        } else {
          return AssetImage(imageURLorPath);
        }
      } else {
        return imageURLorPath;
      }
    } catch (e) {
      //throw error
      throw Exception('Error parsing image: $e');
    }
  }
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child!),
        const Divider(
          height: 1,
        ),
        widget.header ?? const SizedBox.shrink(),
        Column(
          children: [
             Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      widget.setType!("1");
                    },
                    child: Container(
                      color: widget.currentMarkType == "1" ? Palette.scaffold : null,
                      height: 50,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thumb_up, color: Colors.green),
                          SizedBox(width: 10),
                          Text("Trust", style: TextStyle(color: Colors.green))
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      widget.setType!("0");
                    },
                    child: Container(
                      color: widget.currentMarkType == "0" ? Palette.scaffold : null,
                      height: 50,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thumb_down, color: Colors.red),
                          SizedBox(width: 10),
                          Text("Fake", style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 1.0,          // Border width
                ) // Border radius
              ),
              child: ListTile(
                tileColor: widget.backgroundColor,
                leading: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(radius: 50, backgroundImage: widget.userImage),
                ),
                title: Form(
                  key: widget.formKey,
                  child: TextFormField(
                    maxLines: 4,
                    minLines: 1,
                    focusNode: widget.focusNode,
                    cursorColor: widget.textColor,
                    style: TextStyle(color: widget.textColor),
                    controller: widget.commentController,
                    decoration: InputDecoration(
                      enabledBorder: !widget.withBorder
                          ? InputBorder.none
                          : UnderlineInputBorder(
                        borderSide: BorderSide(color: widget.textColor!),
                      ),
                      focusedBorder: !widget.withBorder
                          ? InputBorder.none
                          : UnderlineInputBorder(
                        borderSide: BorderSide(color: widget.textColor!),
                      ),
                      border: !widget.withBorder
                          ? InputBorder.none
                          : UnderlineInputBorder(
                        borderSide: BorderSide(color: widget.textColor!),
                      ),
                      labelText: widget.labelText,
                      focusColor: widget.textColor,
                      fillColor: widget.textColor,
                      labelStyle: TextStyle(color: widget.textColor),
                    ),
                    validator: (value) => value!.isEmpty ? widget.errorText : null,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: widget.sendButtonMethod,
                  child: widget.sendWidget,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
