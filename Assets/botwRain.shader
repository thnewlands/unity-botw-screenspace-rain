Shader "Custom/BOTW-Rain"
{
	Properties
	{
		_MainTex("Camera Texture (leave none)", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_RainDepth("Rain Depth", float) = 1
		_RainDensity("Rain Density", float) = .5
		_RainEdgeHeight("Rain Edge Height", float) = .05
		_RainColor("Rain Color", color) = (1,1,1,.5)
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 scrPos: TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.scrPos = ComputeScreenPos(o.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _NoiseTex;
			sampler2D _MainTex;
			sampler2D _CameraDepthNormalsTexture;
			float4x4 _CameraMV;

			float _RainDepth;
			float _RainDensity;
			float _RainEdgeHeight;
			float4 _RainColor;

			fixed4 frag (v2f i) : SV_Target
			{

				float3 normalValues1;
				float depthValue1;
				float3 normalValues2;
				float depthValue2;

				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.scrPos.xy), depthValue1, normalValues1);
				float3 worldNormal = mul((float3x3)_CameraMV, normalValues1);
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, (i.scrPos.xy - float2(0, _RainEdgeHeight * (1.1-depthValue1) * (1 -worldNormal.g)))), depthValue2, normalValues2);

				fixed4 noise = tex2D(_NoiseTex, (i.uv * (depthValue2 + 2)) + round(_Time[0] * 750) * .1f);
				fixed4 col = tex2D(_MainTex, i.uv);

				if (depthValue1 > depthValue2 * _RainDepth && worldNormal.g > .5f) {
					col += step(noise.r, _RainDensity) * _RainColor;
				}

				return col;
			}
			ENDCG
		}
	}
}
