﻿#ifndef VIRTUAL_DRAW_TEXTURE_INCLUDED
#define VIRTUAL_DRAW_TEXTURE_INCLUDED

Texture2D _Diffuse1;
// sampler2D _Diffuse1;
sampler2D _Diffuse2;
sampler2D _Diffuse3;
sampler2D _Diffuse4;
sampler2D _Normal1;
sampler2D _Normal2;
sampler2D _Normal3;
sampler2D _Normal4;

SamplerState sampler_Diffuse1;

float4x4 _ImageMVP;

sampler2D _Blend;
float4 _BlendTile;

float4 _TileOffset1;
float4 _TileOffset2;
float4 _TileOffset3;
float4 _TileOffset4;

sampler2D _Decal0;
float4 _DecalOffset0;

// albedo and normal of the compressed single tile
sampler2D _TileAlbedo;
sampler2D _TileNormal;

struct pixelOutput_drawTex
{
    float4 col0 : COLOR0;
    float4 col1 : COLOR1;
};

struct v2f_drawTex
{
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
};

v2f_drawTex vert(appdata_img v)
{
    v2f_drawTex o;
    o.pos = mul(_ImageMVP, v.vertex);
    o.uv = v.texcoord;

    return o;
}

pixelOutput_drawTex frag(v2f_drawTex i) : SV_Target
{
    float4 blend = tex2D(_Blend, i.uv * _BlendTile.xy + _BlendTile.zw);

    float4 decal0 = tex2D(_Decal0, i.uv);

    int mip_level = 0;
    float2 transUv = i.uv * _TileOffset1.xy + _TileOffset1.zw;
    // float4 diffuse1 = tex2Dlod(_Diffuse1, float4(transUv, 0, mip_level));
    float4 diffuse1 = _Diffuse1.SampleLevel(sampler_Diffuse1, transUv, mip_level);
    float4 normal1 = tex2Dlod(_Normal1, float4(transUv, 0, mip_level));

    transUv = i.uv * _TileOffset2.xy + _TileOffset2.zw;
    float4 diffuse2 = tex2Dlod(_Diffuse2, float4(transUv, 0, mip_level));
    float4 normal2 = tex2Dlod(_Normal2, float4(transUv, 0, mip_level));

    transUv = i.uv * _TileOffset3.xy + _TileOffset3.zw;
    float4 diffuse3 = tex2Dlod(_Diffuse3, float4(transUv, 0, mip_level));
    float4 normal3 = tex2Dlod(_Normal3, float4(transUv, 0, mip_level));

    transUv = i.uv * _TileOffset4.xy + _TileOffset4.zw;
    float4 diffuse4 = tex2Dlod(_Diffuse4, float4(transUv, 0, mip_level));
    float4 normal4 = tex2Dlod(_Normal4, float4(transUv, 0, mip_level));

    // float2 transUv = i.uv * _TileOffset1.xy + _TileOffset1.zw;
    // float4 diffuse1 = tex2D(_Diffuse1, transUv);
    // float4 normal1 = tex2D(_Normal1, transUv);
    //
    // transUv = i.uv * _TileOffset2.xy + _TileOffset2.zw;
    // float4 diffuse2 = tex2D(_Diffuse2, transUv);
    // float4 normal2 = tex2D(_Normal2, transUv);
    //
    // transUv = i.uv * _TileOffset3.xy + _TileOffset3.zw;
    // float4 diffuse3 = tex2D(_Diffuse3, transUv);
    // float4 normal3 = tex2D(_Normal3, transUv);
    //
    // transUv = i.uv * _TileOffset4.xy + _TileOffset4.zw;
    // float4 diffuse4 = tex2D(_Diffuse4, transUv);
    // float4 normal4 = tex2D(_Normal4, transUv);

    pixelOutput_drawTex o;
    float4 color = blend.r * diffuse1 + blend.g * diffuse2 + blend.b * diffuse3 + blend.a * diffuse4;
    // color.rgb += decal0.rgb * decal0.a;
    o.col0 = color;
    o.col1 = blend.r * normal1 + blend.g * normal2 + blend.b * normal3 + blend.a * normal4;
    return o;
}

// Decal
pixelOutput_drawTex decalFrag(v2f_drawTex i) : SV_Target
{
    float4 blend = tex2D(_Blend, i.uv * _BlendTile.xy + _BlendTile.zw);

    float2 decalUV = i.uv * _DecalOffset0.xy + _DecalOffset0.zw;

    // decalUV =
    //     float2(clamp(i.uv.x + _DecalOffset0.z, 0.0f, 1.0f),
    //            clamp(i.uv.y + _DecalOffset0.w, 0.0f, 1.0f));


    float4 decal0 = tex2D(_Decal0, i.uv);

    int mip_level = 0;
    float2 transUv = i.uv * _TileOffset1.xy + _TileOffset1.zw;
    // float4 diffuse1 = tex2Dlod(_Diffuse1, float4(transUv, 0, mip_level));
    float4 diffuse1 = _Diffuse1.SampleLevel(sampler_Diffuse1, transUv, 0);
    float4 normal1 = tex2Dlod(_Normal1, float4(transUv, 0, mip_level));

    transUv = i.uv * _TileOffset2.xy + _TileOffset2.zw;
    float4 diffuse2 = tex2Dlod(_Diffuse2, float4(transUv, 0, mip_level));
    float4 normal2 = tex2Dlod(_Normal2, float4(transUv, 0, mip_level));

    transUv = i.uv * _TileOffset3.xy + _TileOffset3.zw;
    float4 diffuse3 = tex2Dlod(_Diffuse3, float4(transUv, 0, mip_level));
    float4 normal3 = tex2Dlod(_Normal3, float4(transUv, 0, mip_level));

    transUv = i.uv * _TileOffset4.xy + _TileOffset4.zw;
    float4 diffuse4 = tex2Dlod(_Diffuse4, float4(transUv, 0, mip_level));
    float4 normal4 = tex2Dlod(_Normal4, float4(transUv, 0, mip_level));

    // float2 transUv = i.uv * _TileOffset1.xy + _TileOffset1.zw;
    // float4 diffuse1 = tex2D(_Diffuse1, transUv);
    // float4 normal1 = tex2D(_Normal1, transUv);
    //
    // transUv = i.uv * _TileOffset2.xy + _TileOffset2.zw;
    // float4 diffuse2 = tex2D(_Diffuse2, transUv);
    // float4 normal2 = tex2D(_Normal2, transUv);
    //
    // transUv = i.uv * _TileOffset3.xy + _TileOffset3.zw;
    // float4 diffuse3 = tex2D(_Diffuse3, transUv);
    // float4 normal3 = tex2D(_Normal3, transUv);
    //
    // transUv = i.uv * _TileOffset4.xy + _TileOffset4.zw;
    // float4 diffuse4 = tex2D(_Diffuse4, transUv);
    // float4 normal4 = tex2D(_Normal4, transUv);

    pixelOutput_drawTex o;
    float4 color = blend.r * diffuse1 + blend.g * diffuse2 + blend.b * diffuse3 + blend.a * diffuse4;
    color.rgb += decal0.rgb * decal0.a;
    // color = float4(_DecalOffset0.rg, 0.0, 1.0);
    o.col0 = color;
    o.col1 = blend.r * normal1 + blend.g * normal2 + blend.b * normal3 + blend.a * normal4;
    return o;
}

// Copy Tile To VT
v2f_drawTex tileVert(appdata_img v)
{
    v2f_drawTex o;
    o.pos = v.vertex;
    o.uv = v.texcoord;

    return o;
}

pixelOutput_drawTex copyFrag(v2f_drawTex i) : SV_Target
{
    int mip_level = 0;
    pixelOutput_drawTex o;
    // invert y pls
    o.col0 = tex2Dlod(_TileAlbedo, float4(float2(i.uv.x, 1.0f - i.uv.y), 0, mip_level));
    o.col1 = tex2Dlod(_TileNormal, float4(float2(i.uv.x, 1.0f - i.uv.y), 0, mip_level));
    return o;
}

#endif
