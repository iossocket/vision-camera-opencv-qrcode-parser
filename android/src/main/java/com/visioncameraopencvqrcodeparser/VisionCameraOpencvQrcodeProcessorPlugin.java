package com.visioncameraopencvqrcodeparser;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.YuvImage;
import android.media.Image;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.OptIn;
import androidx.camera.core.ImageProxy;

import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.mrousavy.camera.frameprocessor.FrameProcessorPlugin;

import org.opencv.WeChatQRCodeDetector;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.List;


public class VisionCameraOpencvQrcodeProcessorPlugin extends FrameProcessorPlugin {
  public VisionCameraOpencvQrcodeProcessorPlugin() {
    super("qrcode_processor_plugin");
  }

  @Nullable
  @Override
  @OptIn(markerClass = androidx.camera.core.ExperimentalGetImage.class)
  public Object callback(@NonNull ImageProxy imageProxy, @NonNull Object[] params) {
    WritableNativeMap map = new WritableNativeMap();
    WritableNativeArray array = new WritableNativeArray();
    Image image = imageProxy.getImage();
    if (image == null) {
      map.putArray("barcode", array);
      return map;
    }
    List<String> results = WeChatQRCodeDetector.detectAndDecode(toBitmap(image));
    for (String item : results) {
      array.pushString(item);
    }
    map.putArray("barcode", array);
    return map;
  }

  private Bitmap toBitmap(Image image) {
    Image.Plane[] planes = image.getPlanes();
    ByteBuffer yBuffer = planes[0].getBuffer();
    ByteBuffer uBuffer = planes[1].getBuffer();
    ByteBuffer vBuffer = planes[2].getBuffer();

    int ySize = yBuffer.remaining();
    int uSize = uBuffer.remaining();
    int vSize = vBuffer.remaining();

    byte[] nv21 = new byte[ySize + uSize + vSize];
    //U and V are swapped
    yBuffer.get(nv21, 0, ySize);
    vBuffer.get(nv21, ySize, vSize);
    uBuffer.get(nv21, ySize + vSize, uSize);

    YuvImage yuvImage = new YuvImage(nv21, ImageFormat.NV21, image.getWidth(), image.getHeight(), null);
    ByteArrayOutputStream out = new ByteArrayOutputStream();
    yuvImage.compressToJpeg(new Rect(0, 0, yuvImage.getWidth(), yuvImage.getHeight()), 75, out);

    byte[] imageBytes = out.toByteArray();
    return BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);
  }
}
