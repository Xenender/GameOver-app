import 'package:adaptive_spinner/adaptive_spinner.dart';
import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enhanced_avatar_view/enhanced_avatar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RemotePictureUp extends StatelessWidget {
  final String imagePath;
  final String mapKey;
  final bool useAvatarView;
  final String? storageKey;
  final String? placeholder;
  final double? avatarViewRadius;
  final BoxFit? fit;

  const RemotePictureUp({
    required this.imagePath,
    required this.mapKey,
    this.storageKey,
    this.useAvatarView = false,
    this.placeholder,
    this.avatarViewRadius,
    this.fit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(!useAvatarView || useAvatarView && avatarViewRadius != null);

    return FutureBuilder<String>(
      future: CachedFirestorage.instance.getDownloadURL(
        filePath: imagePath,
        storageKey: storageKey,
        mapKey: mapKey,
      ),
      builder: (_, snapshot) => snapshot.connectionState ==
          ConnectionState.waiting
          ? const Center(
        child: !kIsWeb ? CircularProgressIndicator() : CircularProgressIndicator(),
      )
          : useAvatarView
          ? AvatarView(
        radius: avatarViewRadius!,
        avatarType: AvatarType.circle,
        imagePath:
        snapshot.data != "" ? snapshot.data! : placeholder!,
        placeHolder: Center(
          child: !kIsWeb
              ? Container(width: 0,height: 0,)
              : Container(width: 0,height: 0,)
        ),
        errorWidget:
        placeholder != null ? Image.asset(placeholder!) : null,
      )
          : CachedNetworkImage(
        imageUrl: snapshot.data!,
        placeholder: (_, __) =>  Center(
          child: !kIsWeb
              ? Container(width: 0,height: 0,)
              : Container(width: 0,height: 0,)
        ),
        errorWidget: placeholder != null
            ? (_, __, ___) => Image.asset(placeholder!)
            : null,
        fit: fit,
      ),
    );
  }
}
