// Put this small widget in the same file (below the class) or a widgets/ folder
import 'package:flutter/material.dart';

class _ProductImage extends StatelessWidget {
  final String url;
  const _ProductImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final isNetwork = url.startsWith('http');
    final image = isNetwork
        ? Image.network(
            url,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            // helpful during dev:
            errorBuilder: (_, __, ___) => _error(),
            loadingBuilder: (c, child, progress) {
              if (progress == null) return child;
              return SizedBox(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            (progress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                ),
              );
            },
          )
        : Image.asset(
            url,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _error(),
          );

    return SizedBox(height: 250, width: double.infinity, child: image);
  }

  Widget _error() => Container(
        height: 250,
        color: Colors.blueGrey,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined, size: 48, color: Colors.white70),
      );
}
