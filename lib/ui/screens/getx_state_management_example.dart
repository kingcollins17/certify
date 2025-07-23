import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ExampleController extends GetxController {
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }
}

class GetxStateManagementExample extends StatefulWidget {
  const GetxStateManagementExample({super.key});

  @override
  State<GetxStateManagementExample> createState() {
    return _GetxStateManagementExampleState();
  }
}

class _GetxStateManagementExampleState
    extends State<GetxStateManagementExample> {
  @override
  void initState() {
    Get.put(ExampleController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<ExampleController>();
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          GetBuilder<ExampleController>(
            builder: (controller) {
              return Text(
                controller.isLoading
                    ? 'State is loading'
                    : 'State is not loading',
              );
            },
          ),

          SizedBox(height: 16 * 10),
          GetBuilder<ExampleController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: () {
                    controller.setLoading(!controller.isLoading);
                    // final prev = controller.isLoading.value;
                    // controller.isLoading.value = !prev;
                  },
                  child: Text(controller.isLoading ? 'Loading ...' : 'Toggle'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
