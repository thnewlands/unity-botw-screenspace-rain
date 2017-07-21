Shader "Custom/DepthGrayscale" {
	Properties{
		_MainTex("", 2D) = "white" {}
		_FogColor("Fog Color", color) = (0,0,0,0)
		_FogDistance("Fog Distance", float) = 7
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }

		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _CameraDepthNormalsTexture;
			sampler2D _MainTex;
			float4 _FogColor;
			float _FogDistance;
			float4x4 _CamToWorld;

			float4x4 _CameraMV;

			struct v2f {
				float4 pos : SV_POSITION;
				float4 scrPos:TEXCOORD1;
				float2 uv : TEXCOORD4;
			};

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.scrPos = ComputeScreenPos(o.pos);
				return o;
			}

			half4 frag(v2f i) : COLOR{
				fixed4 combinedColor;
				fixed4 orgColor = tex2Dproj(_MainTex, i.scrPos);

				float depthValue;
				float3 normalValues;
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.scrPos.xy), depthValue, normalValues);
				normalValues = mul((float3x3)_CamToWorld, normalValues);

				float fog = depthValue * _FogDistance;
				fog = clamp(fog, 0, 1);
				return lerp(orgColor, _FogColor, fog);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}