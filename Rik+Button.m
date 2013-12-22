#import "Rik.h"

@implementation Rik(RikButton)


- (NSColor*)  buttonColorInCell:(NSCell*) cell forState: (GSThemeControlState) state
{

  NSColor	*color = nil;
  NSString	*name = [super nameForElement: cell];
  color = [self colorNamed: name state: state];
  if (color == nil)
    {
      if (state == GSThemeNormalState)
        {
          color = [NSColor controlBackgroundColor];
        }
      else if (state == GSThemeHighlightedState
	       || state == GSThemeHighlightedFirstResponderState)
        {
          color = [NSColor selectedControlColor];
        }
      else if (state == GSThemeSelectedState
	       || state == GSThemeSelectedFirstResponderState)
        {
          color = [NSColor selectedControlColor];
        }
      else
        {
          color = [NSColor controlBackgroundColor];
        }
    }
  return color;
}

- (void) _drawRoundBezel: (NSRect)cellFrame
               withColor: (NSColor*)backgroundColor
               andRadius: (CGFloat) radius
{

  NSColor* strokeColorButton = [Rik controlStrokeColor];

  NSGradient* buttonBackgroundGradient = [self _bezelGradientWithColor: backgroundColor];

  cellFrame = NSInsetRect(cellFrame, 0.5, 0.5);
  NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: cellFrame
                                                                       xRadius: radius
                                                                       yRadius: radius];
  [buttonBackgroundGradient drawInBezierPath: roundedRectanglePath angle: -90];
  [strokeColorButton setStroke];
  [roundedRectanglePath setLineWidth: 1];
  [roundedRectanglePath stroke];
}

- (void) _drawRoundBezel: (NSRect)cellFrame withColor: (NSColor*)backgroundColor
{
  [self _drawRoundBezel: cellFrame withColor: backgroundColor andRadius: 4];
}
- (void) _drawRoundedBezel: (NSRect)cellFrame withColor: (NSColor*)backgroundColor
{
  float r = MIN(cellFrame.size.width, cellFrame.size.height) / 2.0;
  [self _drawRoundBezel: cellFrame withColor: backgroundColor andRadius: r];
}
- (void) drawCircularBezel: (NSRect)cellFrame withColor: (NSColor*)backgroundColor
{
  CGFloat circle_radius = MIN(NSWidth(cellFrame), NSHeight(cellFrame)) / 2;
  CGFloat x = cellFrame.origin.x + cellFrame.size.width/2.0 - circle_radius;
  cellFrame = NSMakeRect( x,
                          cellFrame.origin.y,
                          circle_radius*2,
                          circle_radius*2);

  [self _drawRoundBezel: cellFrame withColor: backgroundColor
              andRadius: circle_radius];
}

- (NSGradient *) _bezelGradientWithColor:(NSColor*) baseColor
{
  baseColor = [baseColor colorUsingColorSpaceName: NSCalibratedRGBColorSpace];

  NSColor* baseColorLight = [baseColor highlightWithLevel: 0.8];
  NSColor* baseColorLight2 = [baseColor highlightWithLevel: 0.5];
  NSColor* baseColorShadow = [baseColor shadowWithLevel: 0.1];

  NSGradient* gradient = [[NSGradient alloc] initWithColorsAndLocations:
      baseColorLight, 0.0,
      baseColor, 0.30,
      baseColor, 0.49,
      baseColorLight2, 0.50,
      nil];
  return gradient;
}

- (NSRect) drawButton: (NSRect)border withClip: (NSRect)clip
{
  NSColor * c = [NSColor controlBackgroundColor];
  [self _drawRoundBezel: border withColor: c];
}
- (void) drawButton: (NSRect) frame
				 in: (NSCell*) cell
			   view: (NSView*) view
			  style: (int) style
			  state: (GSThemeControlState) state
{
  NSColor	*color = [self buttonColorInCell: cell forState: state];

  switch (style)
    {
      case NSRoundRectBezelStyle:
        [self _drawRoundBezel: frame withColor: color];
        break;
      case NSTexturedRoundedBezelStyle:
      case NSRoundedBezelStyle:
        [self _drawRoundedBezel: frame withColor: color];
        break;
      case NSTexturedSquareBezelStyle:
        frame = NSInsetRect(frame, 0, 1);
      case NSSmallSquareBezelStyle:
      case NSRegularSquareBezelStyle:
      case NSShadowlessSquareBezelStyle:
        [color set];
        NSRectFill(frame);
        [[Rik controlStrokeColor] set];
        NSFrameRectWithWidth(frame, 1);
        break;
      case NSThickSquareBezelStyle:
        [color set];
        NSRectFill(frame);
        [[Rik controlStrokeColor] set];
        NSFrameRectWithWidth(frame, 1.5);
        break;
      case NSThickerSquareBezelStyle:
        [color set];
        NSRectFill(frame);
        [[NSColor controlShadowColor] set];
        NSFrameRectWithWidth(frame, 2);
        break;
      case NSCircularBezelStyle:
        [self drawCircularBezel: frame withColor: color];
        break;
      case NSHelpButtonBezelStyle:
        [self drawCircularBezel: frame withColor: color];
        {
          NSDictionary *attributes = [NSDictionary dictionaryWithObject: [NSFont controlContentFontOfSize: 0]
                      forKey: NSFontAttributeName];
          NSAttributedString *questionMark = [[[NSAttributedString alloc]
                  initWithString: _(@"?")
                attributes: attributes] autorelease];

          NSRect textRect;
          textRect.size = [questionMark size];
          textRect.origin.x = NSMidX(frame) - (textRect.size.width / 2);
          textRect.origin.y = NSMidY(frame) - (textRect.size.height / 2);

          [questionMark drawInRect: textRect];
        }
        break;
      case NSDisclosureBezelStyle:
      case NSRoundedDisclosureBezelStyle:
      case NSRecessedBezelStyle:
        [self _drawRoundBezel: frame withColor: color];
        break;
      default:
        [self _drawRoundBezel: frame withColor: color];
    }
}

// currently not used
- (void) _drawButtonMetal:(NSRect) rect
{
  NSColor* strokeColorButton = [Rik controlStrokeColor];
  NSColor* baseColor = [NSColor colorWithCalibratedRed: 0.75
                                                 green: 0.75
                                                  blue: 0.75
                                                 alpha: 1];

  NSColor* baseColorLight = [baseColor highlightWithLevel: 0.6];

  NSGradient* buttonBackgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
      baseColorLight, 1.0,
      baseColor, 0.0, nil];
  CGFloat roundedRectangleStrokeWidth = 1;
  NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: rect xRadius: 3 yRadius: 3];
  [buttonBackgroundGradient drawInBezierPath: roundedRectanglePath angle: -90];
  [strokeColorButton setStroke];
  [roundedRectanglePath setLineWidth: roundedRectangleStrokeWidth];
  [roundedRectanglePath stroke];
}
@end