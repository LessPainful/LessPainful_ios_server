//
//  UIScriptASTClassName.h
//  iLessPainfulServer
//
//  Created by Karl Krukow on 12/08/11.
//  Copyright 2011 Trifork. All rights reserved.
//

#import "UIScriptAST.h"

@interface UIScriptASTClassName : UIScriptAST {
    NSString *_className;
    Class _class;
}

@property (nonatomic,retain, readonly) NSString *className;
- (id) initWithClassName:(NSString*) className;

@end
