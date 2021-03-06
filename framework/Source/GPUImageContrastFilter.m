#import "GPUImageContrastFilter.h"

/* Contrast fragment shader:
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float contrast;
 
 void main()
 {
    lowp vec3 textureColor = texture2D(inputImageTexture, textureCoordinate).rgb;
 
    gl_FragColor = vec4(((textureColor - vec3(0.5)) * contrast + vec3(0.5)), 1.0);
 }
 */



NSString *const kGPUImageContrastFragmentShaderString = 
@"varying highp vec2 textureCoordinate;\
\
uniform sampler2D inputImageTexture;\
uniform lowp float contrast;\
\
void main()\
{\
lowp vec3 textureColor = texture2D(inputImageTexture, textureCoordinate).rgb;\
\
gl_FragColor = vec4(((textureColor - vec3(0.5)) * contrast + vec3(0.5)), 1.0);\
}";


@implementation GPUImageContrastFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageContrastFragmentShaderString]))
    {
		return nil;
    }
    
    contrastUniform = [filterProgram uniformIndex:@"contrast"];
    self.contrast = 1.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

@synthesize contrast = _contrast;

- (void)setContrast:(CGFloat)newValue;
{
    _contrast = newValue;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(contrastUniform, _contrast);
}

@end

