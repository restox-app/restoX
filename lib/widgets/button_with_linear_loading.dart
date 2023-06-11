import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ElevatedButtonWithLinearLoading extends ConsumerStatefulWidget {
  const ElevatedButtonWithLinearLoading({
    Key? key,
    required this.child,
  }) : super(key: key);

  final ButtonStyleButton child;

  @override
  ConsumerState createState() => _ElevatedButtonWithLinearLoadingState();
}

class _ElevatedButtonWithLinearLoadingState
    extends ConsumerState<ElevatedButtonWithLinearLoading> {

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30)
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Listener(
              child: ElevatedButton(
                key: widget.child.key,
                onPressed: widget.child.onPressed == null ? null : _loading ? null : () async {
                  setState(() {
                    _loading = true;
                  });
                    if (widget.child.onPressed is AsyncCallback) {
                    await (widget.child.onPressed!() as Future<void>);
                  } else {
                    widget.child.onPressed!();
                  }
                  setState(() {
                    _loading = false;
                  });
                },
                onLongPress: widget.child.onLongPress,
                onHover: widget.child.onHover,
                onFocusChange: widget.child.onFocusChange,
                style: widget.child.style,
                focusNode: widget.child.focusNode,
                autofocus: widget.child.autofocus,
                clipBehavior: widget.child.clipBehavior,
                statesController: widget.child.statesController,
                child: widget.child.child,
              ),
              onPointerUp: (e) {
                setState(() {
                  _loading = true;
                });
              },
            ),
          ),
          AnimatedPositioned(
            bottom: _loading ? 4 : -4,
            left: 5,
            right: 5,
            duration: const Duration(milliseconds: 500),
            child: const LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
