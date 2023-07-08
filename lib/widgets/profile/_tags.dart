
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:youapp_test/models/user_profile.dart';

class TagField extends StatefulWidget {

  final ModelUser user;
  final List<String> updatedTags;
  const TagField({Key? key, required this.user, required this.updatedTags}) : super(key: key);

  @override
  State<TagField> createState() => _TagFieldState();
}

class _TagFieldState extends State<TagField> {
  late double _distanceToField;
  late TextfieldTagsController _controller;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();

  }

  @override
  Widget build(BuildContext context) {

    return TextFieldTags(
      textfieldTagsController: _controller,
      initialTags: widget.updatedTags,
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
      validator: (String tag) {
        if (_controller.getTags!.contains(tag)) {
          return 'you already entered that';
        }
        widget.updatedTags.add(tag);
        print('og tags: ${widget.user.profile.interest}');
        // widget.updateUser(widget.user);
        return null;
      },
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, sc, tags, onTagDelete) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: tec,
              focusNode: fn,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                errorText: error,
                prefixIconConstraints: BoxConstraints(maxWidth: _distanceToField * 0.74),
                prefixIcon: tags.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 17, bottom: 10),
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 8.0,
                    children: tags.map((String tag) {
                      return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          color: Color(0x1AFFFFFF),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.white),
                              ),
                              onTap: () {
                                print("$tag selected");
                              },
                            ),
                            const SizedBox(width: 4.0),
                            InkWell(
                              child: const Icon(
                                Icons.cancel,
                                size: 14.0,
                                color: Color.fromARGB(
                                    255, 233, 233, 233),
                              ),
                              onTap: () {
                                onTagDelete(tag);
                                widget.updatedTags.remove(tag);
                                print('og tags: ${widget.user.profile.interest}');
                                // widget.updateUser(widget.user);
                              },
                            )
                          ],
                        ),
                      );
                    }).toList()
                  ),
                )
                    : null,
              ),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          );
        });
      },
    );
  }
}