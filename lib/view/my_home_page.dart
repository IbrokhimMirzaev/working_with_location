import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_with_location/view_models/location_view_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loader = context.watch<LocationViewModel>().isLoading;
    var placeMarks = context.watch<LocationViewModel>().placeMarks;
    var locations = context.watch<LocationViewModel>().locationList;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Location handling"),
        ),
        body: loader
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "User current location:",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                      ),
                    ),
                    Consumer<LocationViewModel>(
                        builder: (context, viewModelInstance, child) {
                      return Text('''
                      ${viewModelInstance.position.toString()},
                      speed: ${viewModelInstance.position?.speed},
                      accuracy: ${viewModelInstance.position?.accuracy},
                      altitude: ${viewModelInstance.position?.altitude},
                      floor: ${viewModelInstance.position?.floor},
                      timestamp: ${viewModelInstance.position?.timestamp},
              ''');
                    }),
                    Expanded(
                        child: ListView(
                      children: [
                        ...List.generate(placeMarks.length, (index) {
                          var item = placeMarks[index];
                          return ListTile(
                            title: Text(item.country.toString()),
                            subtitle: Text(item.name.toString()),
                          );
                        })
                      ],
                    )),
                    Expanded(
                        child: ListView(
                      children: [
                        ...List.generate(locations.length, (index) {
                          var item = locations[index];
                          return ListTile(
                            title: Text("${item.latitude} - ${item.longitude}"),
                            subtitle: Text(item.timestamp.toString()),
                          );
                        })
                      ],
                    )),
                    TextField(
                      controller: controller,
                    )
                  ],
                ),
              ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                context.read<LocationViewModel>().fetchCurrentPosition();
              },
              child: const Icon(Icons.location_on),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () {
                context.read<LocationViewModel>().fetchAddressFromLatLong();
              },
              child: const Icon(Icons.my_location),
            ),
            FloatingActionButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context
                      .read<LocationViewModel>()
                      .fetchLocationFromText(addressText: controller.text);
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ],
        ));
  }
}
