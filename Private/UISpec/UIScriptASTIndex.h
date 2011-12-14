//
//  UIScriptASTIndex.h
//  iLessPainfulServer
//
//  Created by Karl Krukow on 12/08/11.
//  Copyright 2011 Trifork. All rights reserved.
//

#import "UIScriptAST.h"

@interface UIScriptASTIndex : UIScriptAST {
    NSUInteger _index;
}
@property (nonatomic,assign) NSUInteger index;
- (id)initWithIndex:(NSUInteger)index;
@end
