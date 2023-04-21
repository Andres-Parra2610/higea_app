
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter/material.dart';

class LoadImageWidget extends StatelessWidget {
const LoadImageWidget({ Key? key, required this.imgUrl }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context){

    if(imgUrl.isEmpty){
      return const Image(
        image: AssetImage('assets/no-image.jpg'),
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imgUrl,
        placeholder: (context, url) => const BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fadeInDuration: const Duration(milliseconds: 500),
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}