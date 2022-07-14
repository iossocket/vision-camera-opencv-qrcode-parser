/* global __qrcode_processor_plugin */
import type { Frame } from "react-native-vision-camera";

declare let _WORKLET: true | undefined;
export function qrcodeProcessorPlugin(frame: Frame): string[] {
  "worklet";
  if (!_WORKLET) throw new Error("qrcodeProcessorPlugin must be called from a frame processor!");
  console.log("__qrcode_processor_plugin enter")
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-expect-error because this function is dynamically injected by VisionCamera
  return __qrcode_processor_plugin(frame);
}