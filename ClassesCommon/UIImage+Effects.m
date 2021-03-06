
#import "UIImage+Effects.h"

@import Accelerate;

@implementation DVGImageUtils

+ (UIImage*)imageByApplyingWatermarkToImage:(UIImage*)inputImage atPos:(CGPoint)pos watermark:(UIImage*)watermarkImage {
    UIGraphicsBeginImageContext(inputImage.size);
    [inputImage drawInRect:CGRectMake(0, 0, inputImage.size.width, inputImage.size.height)];
    [watermarkImage drawInRect:CGRectMake(pos.x, pos.y, watermarkImage.size.width, watermarkImage.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    static NSMutableDictionary* imageCaches = nil;
    if(imageCaches == nil){
        imageCaches = @{}.mutableCopy;
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString* cachekey = [NSString stringWithFormat:@"%f-%f-%f-%f-%f-%f",components[0],components[1],components[2],components[3],size.width,size.height];
    UIImage *image = [imageCaches objectForKey:cachekey];
    if(image != nil){
        return image;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageCaches setObject:image forKey:cachekey];
    return image;
}

//| ----------------------------------------------------------------------------
+ (UIImage *)imageByApplyingLightEffectToImage:(UIImage*)inputImage
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self imageByApplyingBlurToImage:inputImage withRadius:60 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


//| ----------------------------------------------------------------------------
+ (UIImage *)imageByApplyingExtraLightEffectToImage:(UIImage*)inputImage
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self imageByApplyingBlurToImage:inputImage withRadius:40 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


//| ----------------------------------------------------------------------------
+ (UIImage *)imageByApplyingDarkEffectToImage:(UIImage*)inputImage
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self imageByApplyingBlurToImage:inputImage withRadius:40 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


//| ----------------------------------------------------------------------------
+ (UIImage *)imageByApplyingTintEffectWithColor:(UIColor *)tintColor toImage:(UIImage*)inputImage
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self imageByApplyingBlurToImage:inputImage withRadius:20 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}

//| ----------------------------------------------------------------------------
+ (UIImage*)imageByApplyingBlurToImage:(UIImage*)inputImage withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
#define ENABLE_BLUR                     1
#define ENABLE_SATURATION_ADJUSTMENT    1
#define ENABLE_TINT                     1
    
    // Check pre-conditions.
    if (inputImage.size.width < 1 || inputImage.size.height < 1)
    {
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", inputImage.size.width, inputImage.size.height, inputImage);
        return nil;
    }
    if (!inputImage.CGImage)
    {
        NSLog(@"*** error: inputImage must be backed by a CGImage: %@", inputImage);
        return nil;
    }
    if (maskImage && !maskImage.CGImage)
    {
        NSLog(@"*** error: effectMaskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    
    CGImageRef inputCGImage = inputImage.CGImage;
    CGFloat inputImageScale = inputImage.scale;
    CGBitmapInfo inputImageBitmapInfo = CGImageGetBitmapInfo(inputCGImage);
    CGImageAlphaInfo inputImageAlphaInfo = (inputImageBitmapInfo & kCGBitmapAlphaInfoMask);
    
    CGSize outputImageSizeInPoints = inputImage.size;
    CGRect outputImageRectInPoints = { CGPointZero, outputImageSizeInPoints };
    
    // Set up output context.
    BOOL useOpaqueContext;
    if (inputImageAlphaInfo == kCGImageAlphaNone || inputImageAlphaInfo == kCGImageAlphaNoneSkipLast || inputImageAlphaInfo == kCGImageAlphaNoneSkipFirst)
        useOpaqueContext = YES;
    else
        useOpaqueContext = NO;
    UIGraphicsBeginImageContextWithOptions(outputImageRectInPoints.size, useOpaqueContext, inputImageScale);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -outputImageRectInPoints.size.height);
    
    if (hasBlur || hasSaturationChange)
    {
        vImage_Buffer effectInBuffer;
        vImage_Buffer scratchBuffer1;
        
        vImage_Buffer *inputBuffer;
        vImage_Buffer *outputBuffer;
        
        vImage_CGImageFormat format = {
            .bitsPerComponent = 8,
            .bitsPerPixel = 32,
            .colorSpace = NULL,
            // (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little)
            // requests a BGRA buffer.
            .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little,
            .version = 0,
            .decode = NULL,
            .renderingIntent = kCGRenderingIntentDefault
        };
        
        vImage_Error e = vImageBuffer_InitWithCGImage(&effectInBuffer, &format, NULL, inputImage.CGImage, kvImagePrintDiagnosticsToConsole);
        if (e != kvImageNoError)
        {
            NSLog(@"*** error: vImageBuffer_InitWithCGImage returned error code %zi for inputImage: %@", e, inputImage);
            UIGraphicsEndImageContext();
            return nil;
        }
        
        vImageBuffer_Init(&scratchBuffer1, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, kvImageNoFlags);
        inputBuffer = &effectInBuffer;
        outputBuffer = &scratchBuffer1;
        
#if ENABLE_BLUR
        if (hasBlur)
        {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * inputImageScale;
            if (inputRadius - 2. < __FLT_EPSILON__)
                inputRadius = 2.;
            uint32_t radius = floor((inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5) / 2);
            
            radius |= 1; // force radius to be odd so that the three box-blur methodology works.
            
            NSInteger tempBufferSize = vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
            void *tempBuffer = malloc(tempBufferSize);
            
            vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(outputBuffer, inputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            
            free(tempBuffer);
            
            vImage_Buffer *temp = inputBuffer;
            inputBuffer = outputBuffer;
            outputBuffer = temp;
        }
#endif
        
#if ENABLE_SATURATION_ADJUSTMENT
        if (hasSaturationChange)
        {
            CGFloat s = saturationDeltaFactor;
            // These values appear in the W3C Filter Effects spec:
            // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/index.html#grayscaleEquivalent
            //
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,                    1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            vImageMatrixMultiply_ARGB8888(inputBuffer, outputBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            
            vImage_Buffer *temp = inputBuffer;
            inputBuffer = outputBuffer;
            outputBuffer = temp;
        }
#endif
        
        CGImageRef effectCGImage;
        if ( (effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, &cleanupBuffer, NULL, kvImageNoAllocate, NULL)) == NULL ) {
            effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, NULL, NULL, kvImageNoFlags, NULL);
            free(inputBuffer->data);
        }
        if (maskImage) {
            // Only need to draw the base image if the effect image will be masked.
            CGContextDrawImage(outputContext, outputImageRectInPoints, inputCGImage);
        }
        
        // draw effect image
        CGContextSaveGState(outputContext);
        if (maskImage)
            CGContextClipToMask(outputContext, outputImageRectInPoints, maskImage.CGImage);
        CGContextDrawImage(outputContext, outputImageRectInPoints, effectCGImage);
        CGContextRestoreGState(outputContext);
        
        // Cleanup
        CGImageRelease(effectCGImage);
        free(outputBuffer->data);
    }
    else
    {
        // draw base image
        CGContextDrawImage(outputContext, outputImageRectInPoints, inputCGImage);
    }
    
#if ENABLE_TINT
    // Add in color tint.
    if (tintColor)
    {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, outputImageRectInPoints);
        CGContextRestoreGState(outputContext);
    }
#endif
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
#undef ENABLE_BLUR
#undef ENABLE_SATURATION_ADJUSTMENT
#undef ENABLE_TINT
}


//| ----------------------------------------------------------------------------
//  Helper function to handle deferred cleanup of a buffer.
//
void cleanupBuffer(void *userData, void *buf_data)
{ free(buf_data); }

//| ----------------------------------------------------------------------------
+ (NSMutableArray*)animatedImageWithImageNameFormatNoCache:(NSString *)imgformat animseqFrom:(int)val_b animseqTo:(int)val_t
{
    NSMutableArray* images = @[].mutableCopy;
    UIImage* img;
    for(int i=val_b;i<=val_t;i++){
        NSString* imgname = [NSString stringWithFormat:imgformat, i];
        //img = [UIImage imageNamed:imgname];
        img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgname ofType:@"png"]];
        if(img){
            [images addObject:img];
        }
    }
    return images;
}

+ (NSMutableArray*)animatedImageWithImageNameFormat:(NSString *)imgformat animseqFrom:(int)val_b animseqTo:(int)val_t
{
    NSMutableArray* images = @[].mutableCopy;
    UIImage* img;
    for(int i=val_b;i<=val_t;i++){
        NSString* imgname = [NSString stringWithFormat:imgformat, i];
        img = [UIImage imageNamed:imgname];
        if(img){
            [images addObject:img];
        }
    }
    return images;
}

+ (UIImageView *)imageViewWithImageNameFormat:(NSString *)imgformat animseqFrom:(int)val_b animseqTo:(int)val_t
{
    NSMutableArray* images = [DVGImageUtils animatedImageWithImageNameFormat:imgformat animseqFrom:val_b animseqTo:val_t];
    UIImage* img = [images firstObject];
    //Position the explosion image view somewhere in the middle of your current view. In my case, I want it to take the whole view.Try to make the png to mach the view size, don't stretch it
    UIImageView* _out = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    _out.animationImages =  images;
    //_out.animationDuration = 0.5;
    _out.animationRepeatCount = 0;
    return _out;
}

@end

@implementation UIImage (DVUtility)

#define MAX_SWAP_ITEMS 100
- (UIImage *)imageWithSwap:(NSDictionary*)colorToColor  cache:(NSString*)cachekey {
    if(colorToColor == nil || colorToColor.count == 0){
        return self;
    }
    UIColor* c2c_keys[MAX_SWAP_ITEMS] = {0};
    UIColor* c2c_vals[MAX_SWAP_ITEMS] = {0};
    size_t c2c_size = 0;
    for(UIColor* c_key in colorToColor){
        c2c_keys[c2c_size] = c_key;
        c2c_vals[c2c_size] = colorToColor[c_key];
        c2c_size++;
        if(c2c_size >= MAX_SWAP_ITEMS-1){
            break;
        }
    }
    static NSMutableDictionary* imageCache = nil;
    if([cachekey length]>0){
        // Adding colorinfo to key
        CGFloat redTmp = 0;
        CGFloat greenTmp = 0;
        CGFloat blueTmp = 0;
        for(int i = 0; i<c2c_size; i++){
            UIColor* c_val = c2c_vals[i];
            [c_val getRed:&redTmp green:&greenTmp blue:&blueTmp alpha:nil];
            cachekey = [cachekey stringByAppendingFormat:@"_%.02f%.02f%.02f", redTmp, greenTmp, blueTmp];
        }
        if(imageCache == nil){
            imageCache = [[NSMutableDictionary alloc] init];
        }
        if(imageCache[cachekey] != nil){
            return imageCache[cachekey];
        }
    }
    CGImageRef imageRef = [self CGImage];
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    //NSLog(@"imageWithSwap %lu %lu", width, height);
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel    = 4;
    size_t bytesPerRow      = width * bytesPerPixel;//(width * bitsPerComponent * bytesPerPixel + 7) / 8;
    size_t dataSize         = bytesPerRow * height;
    unsigned char *pixels = malloc(dataSize);
    memset(pixels,0,(dataSize));
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB(); //color space info which we need to create our drawing env
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpaceRef,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); //draws the image to our env
    CGFloat pixelWei[MAX_SWAP_ITEMS] = {0};
    CGFloat redTmp = 0;
    CGFloat greenTmp = 0;
    CGFloat blueTmp = 0;
    CGFloat wSumm = 0.0;
    for (int y=0;y<height;++y){
        for (int x=0;x<width;++x){
            size_t idx = (width*y+x)*bytesPerPixel;
            CGFloat alpha = ((CGFloat)pixels[idx+0])/255.0;
            CGFloat red = ((CGFloat)pixels[idx+1])/255.0;
            CGFloat green = ((CGFloat)pixels[idx+2])/255.0;
            CGFloat blue = ((CGFloat)pixels[idx+3])/255.0;
            // getting RGB distance to each color in swap map
            // normalizing weights
            // and mixing swap colors accrodingly
            CGFloat maxdst = 0;
            for(int i = 0; i<c2c_size; i++){
                UIColor* c_key = c2c_keys[i];
                [c_key getRed:&redTmp green:&greenTmp blue:&blueTmp alpha:nil];
                CGFloat dstSq = (redTmp-red)*(redTmp-red)+(greenTmp-green)*(greenTmp-green)+(blueTmp-blue)*(blueTmp-blue);
                CGFloat dst = sqrt(dstSq);
                if(dst > maxdst){
                    maxdst = dst;
                }
                pixelWei[i] = dst;
            }
            wSumm = 0.0;
            for(int i = 0; i<c2c_size; i++){
                pixelWei[i] = 1.0 - pixelWei[i]/maxdst;
                wSumm = wSumm + pixelWei[i];
            }
            red = 0;
            green = 0;
            blue = 0;
            for(int i = 0; i<c2c_size; i++){
                //UIColor* c_key = c2c_keys[i];
                UIColor* c_val = c2c_vals[i];
                [c_val getRed:&redTmp green:&greenTmp blue:&blueTmp alpha:nil];
                CGFloat itemWeight = pixelWei[i]/wSumm;
                red += redTmp*itemWeight;
                green += greenTmp*itemWeight;
                blue += blueTmp*itemWeight;
            }

            pixels[idx+1] = red*255.0*alpha;
            pixels[idx+2] = green*255.0*alpha;
            pixels[idx+3] = blue*255.0*alpha;
            pixels[idx+0] = alpha*255.0;
        }
    }
    CGImageRef processedImageRef = CGBitmapContextCreateImage(context); //create a CGIMageRef from our pixeldata
    UIImage* processedImage = [UIImage imageWithCGImage:processedImageRef scale:self.scale orientation:self.imageOrientation];
    CGContextRelease(context);
    free(pixels);
    CGColorSpaceRelease(colorSpaceRef); //release the color space info
    if([cachekey length]>0){
        imageCache[cachekey] = processedImage;
    }
    return processedImage;
}

- (UIImage *)imageRotatedUp {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)imageAspectFillScaledToSize:(CGSize)size
{
    CGSize newSize;
    CGFloat widthRatio = size.width / self.size.width;
    newSize = CGSizeMake(self.size.width * widthRatio, self.size.height * widthRatio);
    CGFloat heightRatio = size.height / newSize.height;
    newSize = CGSizeMake(newSize.width * heightRatio, newSize.height * heightRatio);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithNormalizedOrientation
{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithColor:(UIColor *)color1
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color1 setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)resizableImageWithNamed:(NSString*)named{
    return [UIImage resizableImageWithNamed:named withInsets:UIEdgeInsetsMake(6.f, 6.f, 6.f, 6.f)];
}

+ (UIImage*)resizableImageWithNamed:(NSString*)named withInsets:(UIEdgeInsets)insets{
    UIImage* image = [UIImage imageNamed:named];
    return [image resizableImageWithCapInsets:insets];
}

+ (UIImage *)imageWithImage:(UIImage *)image aspectFilledToSize:(CGSize)newSize
{
    // https://gist.github.com/tomasbasham/10533743
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / image.size.width;
    CGFloat aspectHeight = newSize.height / image.size.height;
    CGFloat aspectRatio = MAX ( aspectWidth, aspectHeight );
    
    scaledImageRect.size.width = image.size.width * aspectRatio;
    scaledImageRect.size.height = image.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

+ (UIImage *)imageWithImage:(UIImage *)image croppedToSize:(CGSize)size
{
    NSInteger newCropWidth, newCropHeight;
    
    //=== To crop more efficently =====//
    if(image.size.width < image.size.height){
        if (image.size.width < size.width) {
            newCropWidth = size.width;
        }
        else {
            newCropWidth = image.size.width;
        }
        newCropHeight = (newCropWidth * size.height)/size.width;
    } else {
        if (image.size.height < size.height) {
            newCropHeight = size.height;
        }
        else {
            newCropHeight = image.size.height;
        }
        newCropWidth = (newCropHeight * size.width)/size.height;
    }
    //==============================//
    
    NSInteger x = image.size.width/2.0 - newCropWidth/2.0;
    NSInteger y = image.size.height/2.0 - newCropHeight/2.0;
    
    CGRect cropRect = CGRectMake(x, y, newCropWidth, newCropHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (UIImage *)imageWithImage:(UIImage *)image croppedToRect:(CGRect)rect
{
    if (image.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * image.scale,
                          rect.origin.y * image.scale,
                          rect.size.width * image.scale,
                          rect.size.height * image.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

+ (UIImage *)imageWithImage:(UIImage *)image withScale:(CGFloat)scale
{
    CGSize imageSize = image.size;
    imageSize.width *= scale;
    imageSize.height *= scale;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [image drawInRect:(CGRect){CGPointZero, imageSize}];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image downscaledToHeight:(CGFloat)height
{
    CGSize imageSize = image.size;
    CGFloat scale = height / imageSize.height;
    if (scale >= 1.0) {
        return image;
    }
    
    imageSize.width *= scale;
    imageSize.height *= scale;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [image drawInRect:(CGRect){CGPointZero, imageSize}];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
