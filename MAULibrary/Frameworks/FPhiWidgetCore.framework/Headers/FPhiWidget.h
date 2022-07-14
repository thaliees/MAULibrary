#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreText/CoreText.h>
#import "FPhiWidgetExtractionData.h"
#import <FPBExtractoriOS/FPBExtractoriOS.h>
#import "FPhiWidgetGraph.h"

/**
 Extraction mode.
 */
typedef NS_ENUM(NSUInteger, FPhiWidgetExtractionMode) {
    
    /**
     Registry wizard
     */
    EMRegister,
    
    /**
     Authenticate.
     */
    EMAuthenticate,
    
};

typedef NS_ENUM(NSUInteger, FPhiWidgetLivenessMode) {
    
    /**
     No liveness mode
     */
    LMLivenessNone,
    
    /**
     liveness blink mode
     */
    LMLivenessBlink,
    
    /**
     liveness move mode
     */
    LMLivenessMove,
    
    /**
     liveness passive mode
     */
    LMLivenessPassive,
    
};

/**
 User control object. Manages ipad and iphone cameras and delivery results from a extraction process.
*/
@interface FPhiWidget : UIViewController <AVPlayerItemOutputPullDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate, FPhiGraphProtocol, NSXMLParserDelegate>

/**
 Extraction mode used to perform extraction process.
 */
@property (nonatomic) FPhiWidgetExtractionMode extractionMode;

/**
 Flag indicating that a stabilization phase is required before proceeding with the extraction
 */
@property (nonatomic) bool stabilizationMode;


/**
 Scanning qr code functionality. Available in Authenticate mode. Default value=false
 */
@property (nonatomic) bool qrMode;

/**
 Enable tutorial feature
 */
@property (nonatomic) bool tutorialFlag;

/**
 Authenticate liveness mode Default value=LMLivenessNone
 */
@property (nonatomic) FPhiWidgetLivenessMode livenessMode;

/**
 Left intentionally undocumented
 */
@property (nonatomic) NSString *livenessMoveDirection;


/**
 Desired width of the camera preview. 0 or less sets the desired width back to the default
 */
@property (nonatomic) int desiredCameraWidth;

/**
 Desired height of the camera preview. 0 or less sets the desired height back to the default
 */
@property (nonatomic) int desiredCameraHeight;

/**
 Optional userTag. Custom app tag recorded in extraction template. 4 bytes length. Additional bytes in NSData will be truncated!!!
 */
@property (nonatomic) NSData* userTags;

/**
 Debug mode property. This property is only for debugging purposes. False by default.
 */
@property (nonatomic) bool debugMode;

/**
 Scene timeout property. This property sets the timeout in the information screens (In seconds, 0 or less not apply).
 */
@property (nonatomic) float sceneTimeout;

/**
 Results of a extraction process.
 */
@property (nonatomic) FPhiWidgetExtractionData *results;
/**
 Results from the previous extraction
 */
@property (nonatomic) CGPoint prevLeftEye;
@property (nonatomic) CGPoint prevRightEye;
@property (nonatomic) CGRect prevFace;

/**
 Liveness diagnostic
 */
@property (nonatomic) FPBLivenessDiagnostic livenessDiagnostic;

/**
 if enabled, returned images are cropped to face rectangle. True by default.
 Activating this feature, face and eyes coordinates do not correspond to the cropped image returned.
 */
@property (nonatomic) bool cropImagesToFace;

/**
 Ratio used to expand or shrink face rectangle.
   ratio=1.0f original face rectangle
   ratio=1.2f 20% bigger face rectangle (default value)
   ratio=0.8f 20% smaller face rectangle
 */
@property (nonatomic) float cropRatio;

/**
 Flag to log images when registring or autheticating
 Default value = true;
 */
@property (nonatomic) bool logImages;

/**
 Compresion quality of the logged images. Between 0.0 and 1.0
 Default value 0.92
 */
@property (nonatomic) float jpgQuality;

/**
 optional locale used to programatically force widget locale.
 */
@property (nonatomic) NSString *locale;

/**
 Whether the templateRaw will be optimized or not.
 */
@property (nonatomic) bool templateRawOptimized;


/**
 Initialize a new user control object.
 param frontCameraIfAvailable: By default rear camera used. If device's front camera is available and frontCameraIfAvailable is true, front camera is used.
 */
- (id)initWithFrontCameraIfAvailable :(bool)frontCameraIfAvailable resources:(NSString *)resourcesPath delegate:(id)delegate error:(NSError **)error;

/**
 Start a full extraction process. When process was finished ExtractionFinished method from protocol FPhiUCProtocol is executed.
 */
- (void)StartExtraction;

/**
 Stops a extraction process.
 */
- (void)StopExtraction;

/**
 Transform rectangle from camera image space to display space.
 Extractor returns face and eyes information in image space. Use this method to calculate in display space in order to paint in the correct place.
 */
//-(CGRect)TransformToDisplaySpace:(CGRect)imageSpaceRectangle;

/**
 Return byte buffer representation of img in PNG Format
 */
+(NSData *)PNGRepresentationFromImage :(UIImage *)img;

/**
 Return byte byffer representation of img in JPEG Format.
 Parameter compressionQuality: Range [0..1]
 */
+(NSData *)JPGRepresentationFromImage :(UIImage *)img :(CGFloat)compressionQuality;

@end
