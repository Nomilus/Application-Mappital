import 'package:application_mappital/core/utility/sos_utility.dart';
import 'package:application_mappital/view/event/drawer_controller.dart';
import 'package:application_mappital/view/event/home_controller.dart';
import 'package:application_mappital/view/widget/drawer_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide DrawerController;
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());
  final DrawerController drawerController = Get.put(DrawerController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(onTap: controller.moveToLocation),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() {
                return _buildGoogleMap();
              }),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.2 * 255).toInt()),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerLow,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "sos",
            onPressed: () => SosUtility.showSos(),
            foregroundColor: theme.iconTheme.color,
            backgroundColor: theme.colorScheme.surfaceContainerLow,
            child: const Icon(Icons.sos),
          ),
          FloatingActionButton(
            heroTag: "location",
            onPressed: controller.moveToSelfLocation,
            foregroundColor: theme.iconTheme.color,
            backgroundColor: theme.colorScheme.surfaceContainerLow,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: (value) => controller.mapController(value),
      initialCameraPosition: CameraPosition(
        target: Get.arguments ?? const LatLng(13.7563, 100.5018),
        zoom: 11,
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
      },
      markers: controller.markers.value ?? {},
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}
