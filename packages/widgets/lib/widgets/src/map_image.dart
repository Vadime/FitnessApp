import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:invert_colors/invert_colors.dart';
import 'package:latlng/latlng.dart' as latlng;
import 'package:map/map.dart' as map_package;
import 'package:widgets/widgets.dart';

class MapImageWidget extends StatelessWidget {
  final String adress;
  final Function()? onTap;
  final EdgeInsets margin;

  const MapImageWidget(
    this.adress, {
    this.margin = EdgeInsets.zero,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.config.radius),
          child: SizedBox(
            height: 150,
            child: FutureBuilder<List<geocoding.Location>>(
                future: geocoding.locationFromAddress(adress),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CardWidget.single(
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      child: const Center(
                          child: TextWidget('Karte kann nicht gezeigt werden!',
                              color: Colors.grey, margin: EdgeInsets.all(20))),
                    );
                  }
                  if (!snapshot.hasData) {
                    // return const AppShimmer(
                    //     child: CardWidget.single(backgroundColor: Colors.white70));
                    return const LoadingWidget();
                  }

                  geocoding.Location loc = snapshot.data!.first;
                  Widget map = map_package.MapLayout(
                    controller: map_package.MapController(
                        location: latlng.LatLng(loc.latitude, loc.longitude),
                        zoom: 16),
                    builder: (context, transformer) {
                      return map_package.TileLayer(
                        builder: (context, x, y, z) {
                          final tilesInZoom = pow(2.0, z).floor();

                          while (x < 0) {
                            x += tilesInZoom;
                          }
                          while (y < 0) {
                            y += tilesInZoom;
                          }

                          x %= tilesInZoom;
                          y %= tilesInZoom;

                          //Google Maps
                          final url =
                              'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                          return Image.network(url, fit: BoxFit.cover);
                        },
                      );
                    },
                  );
                  if (Theme.of(context).brightness == Brightness.dark) {
                    map = InvertColors(child: map);
                  }
                  return map;
                }),
          ),
        ),
      ),
    );
  }
}
