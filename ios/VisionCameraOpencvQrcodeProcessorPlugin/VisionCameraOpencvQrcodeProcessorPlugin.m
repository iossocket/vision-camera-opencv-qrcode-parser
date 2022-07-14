#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/Frame.h>

@interface VisionCameraOpencvQrcodeProcessorPluginPlugin : NSObject
@end

@implementation VisionCameraOpencvQrcodeProcessorPluginPlugin

static inline id qrcode_processor_plugin(Frame* frame, NSArray* args) {
  CMSampleBufferRef buffer = frame.buffer;
  CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(buffer);
  CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
  CIContext *temporaryContext = [CIContext contextWithOptions:nil];
  CGImageRef videoImage = [temporaryContext
                           createCGImage:ciImage
                           fromRect: CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))
  ];
  UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
  CGImageRelease(videoImage);
  NSArray<NSString *> *barcodes = [VisionCameraOpencvQrcodeProcessorPluginPlugin detectQRCode:uiImage];
  return @{ @"barcodes": barcodes };
}

+ (NSArray *)detectQRCode:(UIImage *)image {
    if (image == nil || image.CGImage == nil) {
        return [NSArray array];
    }
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    if (ciImage == nil) {
        return [NSArray array];
    }

    NSDictionary *options = @{};
    if ([[ciImage properties] valueForKey:(NSString*)kCGImagePropertyOrientation] == nil) {
        options = @{ CIDetectorImageOrientation : @1};
    } else {
        options = @{ CIDetectorImageOrientation : [[ciImage properties] valueForKey:(NSString*)kCGImagePropertyOrientation] };
    }

    CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext context] options: @{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray<CIFeature *> *features = [qrDetector featuresInImage:ciImage options:options];
    if (features == nil || features.count == 0) {
        return [NSArray array];
    }
    
    NSMutableArray<NSString *> *barcodes = [NSMutableArray array];
    [features enumerateObjectsUsingBlock:^(CIFeature * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id qr = [obj valueForKeyPath:@"messageString"];
        if ([qr isKindOfClass:[NSString class]]) {
            [barcodes addObject:(NSString *)qr];
        }
    }];
    
    return barcodes;
}

VISION_EXPORT_FRAME_PROCESSOR(qrcode_processor_plugin)

@end
