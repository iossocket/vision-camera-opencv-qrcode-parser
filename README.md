# vision-camera-opencv-qrcode-parser
React Native Vision Camera Frame Processor Plugin of OpenCV QR Parser
## Installation

```sh
npm install vision-camera-opencv-qrcode-parser
```

## Usage

```
const frameProcessor = useFrameProcessor((frame) => {
  "worklet";
  const values = qrcodeProcessorPlugin(frame);
  console.log(`frameProcessor Return Values: ${JSON.stringify(values)}`);
}, []);
```

Add this in `babel.config.js`
```
module.exports = {
  ...
  plugins: [
    ...
    [
      "react-native-reanimated/plugin",
      {
        globals: [ "__qrcode_processor_plugin" ]
      }
    ]
  ],
};
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
