//
//  MomentDBHelper.h
//  MomentHub
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MomentDBHelper : NSObject

+ (MomentDBHelper *)sharedInstance;

- (void)getMomentList:(NSInteger)fromIndex userID:(NSString*)userID completed:(void (^)(NSMutableArray* momentArr, NSError *error))completed;

@end
