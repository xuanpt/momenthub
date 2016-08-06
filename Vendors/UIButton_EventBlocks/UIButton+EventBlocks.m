// The MIT License (MIT)

// Copyright (c) 2014 Jan Cássio

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIButton+EventBlocks.h"
#import <objc/runtime.h>

@interface UIButton (_EventBlocks_)

- (void)button:(UIButton *)button touchUpInsideWithEvent:(UIEvent *)event;

@end

@implementation UIButton (EventBlocks)

@dynamic onTouchUpInside;

static void *onTouchUpInsideKey = &onTouchUpInsideKey;

- (void)setOnTouchUpInside:(UIEventBlock)onTouchUpInside
{
  if(onTouchUpInside)
  {
    objc_setAssociatedObject(self, onTouchUpInsideKey, onTouchUpInside, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(button:touchUpInsideWithEvent:) forControlEvents:UIControlEventTouchUpInside];
  }
  else
  {
    objc_setAssociatedObject(self, onTouchUpInsideKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(button:touchUpInsideWithEvent:) forControlEvents:UIControlEventTouchUpInside];
  }
}

- (UIEventBlock)onTouchUpInside
{
  return objc_getAssociatedObject(self, onTouchUpInsideKey);
}

- (void)button:(UIButton *)button touchUpInsideWithEvent:(UIEvent *)event
{
  self.onTouchUpInside(button, event);
}

@end
