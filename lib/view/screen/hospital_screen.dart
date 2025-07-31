import 'package:flutter/material.dart';
import 'package:application_mappital/public/model/hospital_model.dart';
import 'package:application_mappital/view/event/hospital_controller.dart';
import 'package:get/get.dart';

class HospitalScreen extends StatelessWidget {
  HospitalScreen({super.key, required this.hospital});

  final HospitalModel hospital;
  final HospitalController controller = Get.put(HospitalController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ThemeData theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            children: [
              Divider(
                indent: mediaQuery.size.width / 2.7,
                endIndent: mediaQuery.size.width / 2.7,
                color: theme.colorScheme.outline,
                radius: BorderRadius.circular(100),
                thickness: 6,
                height: 16,
              ),
              _buildHeaderContent(hospital: hospital, theme: theme),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: const [],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderContent({
    required HospitalModel hospital,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(hospital.title, style: theme.textTheme.titleMedium),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 0,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close_rounded),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
