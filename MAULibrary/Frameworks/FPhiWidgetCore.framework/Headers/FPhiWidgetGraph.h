
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol FPhiGraphProtocol <NSObject>

-(void)NewState :(NSString *)stateName;

@end


@interface FPhiWidgetGraph : NSObject<NSXMLParserDelegate>

-(bool)hasMessageTransition:(NSString *)message verbose:(bool)verbose;
-(void)sendMessage:(NSString *)message;
-(void)setInitialState:(NSString *)stateName;
+(FPhiWidgetGraph *)loadFromFile:(NSString *)url :(id)delegateState;

@end
