// --------------------------------------------------------------------------------------
// Modified by: OE4m
// Original Source: Microsoft Windows Terminal Samples (https://github.com/microsoft/terminal/blob/main/samples/PixelShaders/Retro.hlsl)
// License: MIT (See original repository for full license)
// --------------------------------------------------------------------------------------

Texture2D shaderTexture;
SamplerState samplerState;

cbuffer PixelShaderSettings
{
    float time;
    float scale;
    float2 resolution;
    float4 background;
};

#define SCANLINE_FACTOR 0.5f
#define SCALED_SCANLINE_PERIOD scale
#define SCALED_GAUSSIAN_SIGMA (2.0f * scale)

static const float M_PI = 3.14159265f;

float Gaussian2D(float x, float y, float sigma)
{
    return 1 / (sigma * sqrt(2 * M_PI)) * exp(-0.5 * (x * x + y * y) / sigma / sigma);
}

float4 Blur(Texture2D input, float2 tex_coord, float sigma)
{
    float width, height;
    shaderTexture.GetDimensions(width, height);

    float texelWidth = 1.0f / width;
    float texelHeight = 1.0f / height;

    float4 color = { 0, 0, 0, 0 };

    float sampleCount = 13;

    for (float x = 0; x < sampleCount; x++)
    {
        float2 samplePos = { 0, 0 };
        samplePos.x = tex_coord.x + (x - sampleCount / 2.0f) * texelWidth;

        for (float y = 0; y < sampleCount; y++)
        {
            samplePos.y = tex_coord.y + (y - sampleCount / 2.0f) * texelHeight;
            color += input.Sample(samplerState, samplePos) * Gaussian2D(x - sampleCount / 2.0f, y - sampleCount / 2.0f, sigma);
        }
    }

    return color;
}


float4 GetColorOverTime(float time)
{
    // Oscillate between two colors over time
    float3 color1 = float3(1.0f, 1.0f, 1.0f);
    float3 color2 = float3(0.9f, 0.9f, 0.9f);
    
    float speed = 100000.0f;
    float t = sin(time * speed) * 0.5f + 0.5f; // Normalize time to [0, 1]
    return float4(lerp(color1, color2, t), 1.0f);
}


float SquareWave(float y)
{
    return 1.0f - (floor(y / SCALED_SCANLINE_PERIOD) % 2.0f) * SCANLINE_FACTOR;
}

float4 Scanline(float4 color, float4 pos)
{
    float wave = SquareWave(pos.y);

    // TODO:GH#3929 make this configurable.
    // Remove the && false to draw scanlines everywhere.
    if (length(color.rgb) < 0.2f && false)
    {
        return color + wave * 0.1f;
    }
    else
    {
        return color * wave;
    }
}

// clang-format off
float4 main(float4 pos : SV_POSITION, float2 tex : TEXCOORD) : SV_TARGET
// clang-format on
{
    // TODO:GH#3930 Make these configurable in some way.
    float4 color = shaderTexture.Sample(samplerState, tex);
    color += Blur(shaderTexture, tex, SCALED_GAUSSIAN_SIGMA) * 0.2f;
    color = Scanline(color, pos);
    color.rgb *= GetColorOverTime(time);

    return color;
}

