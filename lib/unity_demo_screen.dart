import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:iitj_ram/unity_controller.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

import 'statemodel.dart';

class UnityDemoScreen extends StatefulWidget {
  const UnityDemoScreen({super.key});

  @override
  _UnityDemoScreenState createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen>
    with WidgetsBindingObserver {
  UnityWidgetController? _unityWidgetController;

  @override
  void initState() {
    super.initState();
    toggleLineVisibility();
    WidgetsBinding.instance.addObserver(this);
    // Request permissions using the StateModel
    Provider.of<StateModel>(context, listen: false).requestPermissions();
  }

  @override
  void dispose() {
    _sendBackToPreviousScreenMessage();
    _unityWidgetController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }

  void onUnityMessage(dynamic message) {
    if (message == 'SceneLoaded') {
      Provider.of<StateModel>(context, listen: false).setSceneLoaded(true);
      print('Received scene loaded message from Unity');
    } else {
      compute(processUnityMessage, message);
    }
  }

  Future<void> _sendBackToPreviousScreenMessage() async {
    _unityWidgetController?.postMessage(
      'FlutterCommunicationManager',
      'BackToPreviousScreen',
      'true',
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_unityWidgetController == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _unityWidgetController!.resume();
        Provider.of<StateModel>(context, listen: false).setSceneLoaded(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _unityWidgetController!.pause();
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  void sendScanMessageToUnity() {
    _unityWidgetController?.postMessage(
      'QrCodeRecenter',
      'RescanQRCode',
      'true',
    );
  }

  void sendDropdownValueToUnity(String value) {
    _unityWidgetController?.postMessage(
      'Indicator',
      'SetNavigationTargetFromFlutter',
      value,
    );
  }

  void sendYOffsetToUnity(double yOffset) {
    _unityWidgetController?.postMessage(
      'Indicator',
      'SetYOffset',
      yOffset.toString(),
    );
  }

  void toggleLineVisibility() {
    final model = Provider.of<StateModel>(context, listen: false);
    model.toggleLineVisibility();
    _unityWidgetController?.postMessage(
      'Indicator',
      'setToggleVisibility',
      'true',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) =>
            Consumer<StateModel>(
              builder: (context, model, child) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Stack(
                    children: [
                      UnityWidget(
                        onUnityCreated: onUnityCreated,
                        onUnityMessage: onUnityMessage,
                      ),
                      if (model.isSceneLoaded)
                        Positioned(
                          bottom: constraints.maxHeight * 0.32,
                          left: constraints.maxWidth * 0.05,
                          right: constraints.maxWidth * 0.55,
                          child: PointerInterceptor(
                            child: ElevatedButton(
                              onPressed: sendScanMessageToUnity,
                              child: const Text(
                                'Scan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(model.isSceneLoaded)
                        Positioned(
                          bottom: constraints.maxHeight * 0.32,
                          left: constraints.maxWidth * 0.48,
                          right: constraints.maxWidth * 0.05,
                          child: PointerInterceptor(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              height: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  items: <String>[
                                    'Project_Director(Ihub)',
                                    'VishakhaMaamOffice',
                                    'DigitalGamingLab',
                                    'MixedRealityLab',
                                    'MainGate',
                                    'ErpDivision',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      model.setSelectedTarget(newValue);
                                      sendDropdownValueToUnity(newValue);
                                    }
                                  },
                                  hint: Text(
                                    model.selectedTarget ?? 'Select Target',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  dropdownColor: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(model.isSceneLoaded)
                        Positioned(
                          bottom: constraints.maxHeight * 0.05,
                          left: constraints.maxWidth * 0.45,
                          right: constraints.maxWidth * 0.05,
                          child: PointerInterceptor(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RotatedBox(
                                  quarterTurns: -1,
                                  child: SizedBox(
                                    width: constraints.maxWidth * 0.5,
                                    child: Slider(
                                      value: model.yOffset,
                                      min: -1.5,
                                      max: 1.0,
                                      divisions: 100,
                                      label: model.yOffset.toStringAsFixed(2),
                                      onChanged: (double value) {
                                        model.setYOffset(value);
                                        sendYOffsetToUnity(value);
                                      },
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: toggleLineVisibility,
                                  child: Text(
                                    model.lineVisible ? 'Hide Line' : 'Show Line',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}