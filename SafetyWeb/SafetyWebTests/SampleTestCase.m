//
//  SampleTestCase.m
//  SafetyWeb
//
//  Created by Gregory Schmelter on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@interface SampleLibTest : GHTestCase { }
@end

@implementation SampleLibTest {
    
}

-(void)testSimplePass {
    // Another test
}

-(void)testSimpleFail {
    GHAssertTrue(NO, nil);
}

@end
