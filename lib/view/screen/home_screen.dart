import 'package:application_mappital/view/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:application_mappital/view/event/home_controller.dart';
import 'package:application_mappital/view/widget/drawer_widget.dart';
import 'package:application_mappital/view/widget/end_drawer_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(
        userProfileOnPressed: () => Get.toNamed("/profile"),
        onTap: controller.moveToLocation,
      ),
      endDrawer: const EndDrawerWidget(notifications: []),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: _buildGoogleMap()),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                constraints: const BoxConstraints(maxHeight: 50),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Builder(
                        builder: (context) => IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: const Icon(Icons.menu_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.surfaceContainerLow,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SearchWidget()),
                    Expanded(
                      flex: 0,
                      child: Builder(
                        builder: (context) => IconButton(
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                          icon: const Icon(Icons.notifications),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.surfaceContainerLow,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "location",
        onPressed: controller.moveToSelfLocation,
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: (value) => controller.mapController(value),
      initialCameraPosition: const CameraPosition(
        target: LatLng(13.7563, 100.5018),
        zoom: 11,
      ),
      markers: controller.markers.value ?? {},
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}
