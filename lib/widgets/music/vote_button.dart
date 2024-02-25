/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 *
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright (c) 2021-2022, Ankit Sangwan
 */

import 'package:audio_service/audio_service.dart';
import 'package:oxoo/helpers/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../models/favourite_response_model.dart';
import '../../models/user_model.dart';
import '../../server/repository.dart';
import '../../service/authentication_service.dart';
import '../../utils/validators.dart';

class VoteButton extends StatefulWidget {
  final MediaItem? mediaItem;
  final double? size;
  final Map? data;
  final bool showSnack;
  const VoteButton({
    required this.mediaItem,
    this.size,
    this.data,
    this.showSnack = false,
  });

  @override
  _VoteButtonState createState() => _VoteButtonState();
}

class _VoteButtonState extends State<VoteButton>
    with SingleTickerProviderStateMixin {
  bool liked = false;
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    _scale = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(_curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    AuthUser? authUser = authService.getUser();
    try {
      if (widget.mediaItem != null) {
        liked = checkPlaylist('Favorite Songs', widget.mediaItem!.id);
      } else {
        liked = checkPlaylist('Favorite Songs', widget.data!['id'].toString());
      }
    } catch (e) {
      Logger.root.severe('Error in likeButton: $e');
    }
    return ScaleTransition(
      scale: _scale,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
        ),
        child: Text ("Vote"),
        onPressed: () async {
          FavouriteResponseModel? favouriteResponseModel =
          await (Repository().addSongVote(authUser?.userId,widget.mediaItem == null
              ? widget.data!['id'].toString()
              : widget.mediaItem!.id));
          showShortToast(favouriteResponseModel!.message!);
        },
      ),
    );
  }
}
