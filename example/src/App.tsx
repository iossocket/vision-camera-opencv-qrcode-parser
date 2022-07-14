import * as React from "react";

import { StyleSheet, View } from "react-native";
import { useCameraDevices, Camera, useFrameProcessor } from "react-native-vision-camera";
import { qrcodeProcessorPlugin } from "vision-camera-opencv-qrcode-parser";

export default function App() {
  return (
    <ScanBarCodeScreen />
  );
}

export const ScanBarCodeScreen: React.FC = (): React.ReactElement => {
  const devices = useCameraDevices();
  const device = devices.back;

  const frameProcessor = useFrameProcessor((frame) => {
    "worklet";
    const values = qrcodeProcessorPlugin(frame);
    console.log(`frameProcessor Return Values: ${JSON.stringify(values)}`);
  }, []);

  if (device == null) {
    return <View />;
  }
  console.log(`frameProcessor: ${device.supportsParallelVideoProcessing}`);

  return <Camera
    device={device}
    isActive={true}
    style={StyleSheet.absoluteFill}
    frameProcessorFps={"auto"}
    frameProcessor={frameProcessor}
  />;
};
