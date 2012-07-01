M_PI = 3.14159265358979323846

class PieChartItemColor
  attr_accessor :red, :green, :blue, :alpha
  def initialize(r,g,b,a)
    self.red = r
    self.green = g
    self.blue = b
    self.alpha = a
  end
end

class PieChartItem
  attr_accessor :color
  attr_accessor :value
  def initialize(_value, _color)
    self.value = _value
    self.color = _color
  end
end

class PieChartView < UIView
  attr_accessor :no_data_fill_color, :gradient_fill_color, :gradient_fill_start, :gradient_fill_end
  def pie_items
    @pie_items ||= []
  end
  def add_item(value, color)
    pie_items << PieChartItem.new(value, color)
  end

  def init_defaults
    self.gradient_fill_color ||= PieChartItemColor.new(0.0, 0.0, 0.0, 0.4)
    self.gradient_fill_start ||= 0.3
    self.gradient_fill_end   ||= 1.0
    self.no_data_fill_color  ||= PieChartItemColor.new(0.0, 0.0, 0.0, 0.4)
    self.backgroundColor     ||= UIColor.clearColor
  end


  def initWithFrame( aRect )
    init_defaults
    super
    self
  end

  def initWithCoder(decoder)
    init_defaults
    super
    self
  end

  def drawRect(rect)
    startDeg = 0.0
    endDeg = 0.0

    x = self.bounds.size.width/2
    y = self.bounds.size.height/2
    r = (((self.bounds.size.width > self.bounds.size.height) ? self.bounds.size.height : self.bounds.size.width)/2 * 0.8).to_i

    ctx = UIGraphicsGetCurrentContext()
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 0.4)
    CGContextSetLineWidth(ctx, 1.0)

    # Draw a thin line around the circle
    CGContextAddArc(ctx, x, y, r, 0.0, 360.0*M_PI/180.0, 0)
    CGContextClosePath(ctx)
    CGContextDrawPath(ctx, 2) #kCGPathStroke)

    # Loop through all the values and draw the graph
    startDeg = 0.0

    self.pie_items.each_with_index do |item, idx|
      color = item.color

      theta = 360.0 * (item.value.to_f/pie_items.inject(0){|sum,i|sum+i.value})

      if theta > 0.0
        endDeg += theta

        if startDeg != endDeg
          CGContextSetRGBFillColor(ctx, color.red, color.green, color.blue, color.alpha)
          CGContextMoveToPoint(ctx, x, y)
          CGContextAddArc(ctx, x, y, r, (startDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0)
          CGContextClosePath(ctx)
          CGContextFillPath(ctx)
        end
      end

      startDeg = endDeg
    end

    # Draw the remaining portion as a no-data-fill color, though there should never be one. (current code doesn't allow it)
    if endDeg < 360.0
      startDeg = endDeg
      endDeg = 360.0

      if startDeg != endDeg
        CGContextSetRGBFillColor( ctx, no_data_fill_color.red, no_data_fill_color.green, no_data_fill_color.blue, no_data_fill_color.alpha )
        CGContextMoveToPoint(ctx, x, y)
        CGContextAddArc(ctx, x, y, r, (startDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0)
        CGContextClosePath(ctx)
        CGContextFillPath(ctx)
      end
    end

    # Now we want to create an overlay for the gradient to make it look *fancy*
    # We do this by:
    # (0) Create circle mask
    # (1) Creating a blanket gradient image the size of the piechart
    # (2) Masking the gradient image with a circle the same size as the piechart
    # (3) compositing the gradient onto the piechart

    # (0)
    mask_image = self.create_circle_mask_using_center_point_and_radius( CGPointMake(x, y), r)

    # (1)
    gradient_image = self.create_gradient_image_using_rect( self.bounds )

    # (2)
    fade_image = self.mask_image( gradient_image, mask_image )

    # (3)
    CGContextDrawImage(ctx, self.bounds, fade_image.CGImage)

    # Finally set shadows
    self.layer.shadowRadius = 10.0
    self.layer.shadowColor = UIColor.blackColor.CGColor
    self.layer.shadowOpacity = 0.6
    self.layer.shadowOffset = CGSizeMake(0.0, 5.0)
  end

  def mask_image(image, mask_image)
    maskRef = mask_image.CGImage
    mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                             CGImageGetHeight(maskRef),
                             CGImageGetBitsPerComponent(maskRef),
                             CGImageGetBitsPerPixel(maskRef),
                             CGImageGetBytesPerRow(maskRef),
                             CGImageGetDataProvider(maskRef),
                             nil,
                             false)
    masked = CGImageCreateWithMask(image.CGImage, mask)
    UIImage.imageWithCGImage(masked)
  end
  def create_circle_mask_using_center_point_and_radius(point, radius)
    UIGraphicsBeginImageContext( self.bounds.size )
    ctx2 = UIGraphicsGetCurrentContext()
    CGContextSetRGBFillColor(ctx2, 1.0, 1.0, 1.0, 1.0 )
    CGContextFillRect(ctx2, self.bounds)
    CGContextSetRGBFillColor(ctx2, 0.0, 0.0, 0.0, 1.0 )
    CGContextMoveToPoint(ctx2, point.x, point.y)
    CGContextAddArc(ctx2, point.x, point.y, radius, 0.0, (360.0)*M_PI/180.0, 0)
    CGContextClosePath(ctx2)
    CGContextFillPath(ctx2)
    mask_image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsPopContext()
    mask_image
  end
  def create_gradient_image_using_rect(rect)
    UIGraphicsBeginImageContext( rect.size )
    ctx3 = UIGraphicsGetCurrentContext()

    locations  = [
                   1.0 - gradient_fill_start,
                   1.0 - gradient_fill_end
                 ]
    locations_p = Pointer.new(:float, 2)
    locations.each_with_index{|i,idx|locations_p[idx]=i}
    components = [
                   0.0,
                   0.0,
                   0.0,
                   0.0,
                   gradient_fill_color.red,
                   gradient_fill_color.green,
                   gradient_fill_color.blue,
                   gradient_fill_color.alpha
                 ]
    components_p = Pointer.new(:float, 8)
    components.each_with_index{|i,idx|components_p[idx]=i}

    rgb_colorspace = CGColorSpaceCreateDeviceRGB()
    gradient = CGGradientCreateWithColorComponents(rgb_colorspace, components_p, locations_p, locations.size)

    current_bounds = rect
    top_center_point = CGPointMake(CGRectGetMidX(current_bounds), CGRectGetMinY(current_bounds))
    bottom_center_point = CGPointMake(CGRectGetMidX(current_bounds), CGRectGetMaxY(current_bounds))
    CGContextDrawLinearGradient(ctx3, gradient, top_center_point, bottom_center_point, 0)

    gradient_image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsPopContext()

    gradient_image
  end
end
