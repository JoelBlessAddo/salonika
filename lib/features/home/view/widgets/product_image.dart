// lib/features/home/view/widgets/net_image.dart
import 'package:flutter/material.dart';

class NetImage extends StatelessWidget {
  final String urlOrAsset;
  final double height;
  final double? width;
  final BoxFit fit;

  const NetImage(
    this.urlOrAsset, {
    super.key,
    this.height = 120,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = urlOrAsset.startsWith('http');
    final img = isNetwork
        ? Image.network(
            urlOrAsset,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: (_, __, ___) => _error(),
            loadingBuilder: (c, child, progress) {
              if (progress == null) return child;
              return SizedBox(
                height: height,
                width: width,
                child: Center(child: CircularProgressIndicator(value: _val(progress))),
              );
            },
          )
        : Image.asset(
            urlOrAsset,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: (_, __, ___) => _error(),
          );
    return img;
  }

  double? _val(ImageChunkEvent e) {
    if (e.expectedTotalBytes == null) return null;
    return e.cumulativeBytesLoaded / (e.expectedTotalBytes ?? 1);
  }

  Widget _error() => Container(
        height: height,
        width: width,
        color: const Color(0xFFEAEAEA),
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      );
}
