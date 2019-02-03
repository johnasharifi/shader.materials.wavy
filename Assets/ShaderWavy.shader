Shader "Custom/ShaderWavy" {
	Properties{
		_BaseColor("Base color", Color) = (1.0, 1.0, 1.0, 1.0)
		_PeakColor("Peak color", Color) = (0.3, 0.0, 0.0, 1.0)
		_TroughColor("Trough color", Color) = (0.0, 0.0, 0.0, 1.0)

		_Theta("World wave - direction", Range(0, 3.14)) = 1.57
		_Amplitude("World wave - height", Range(0, 1)) = 0.1
		_Speed("World wave - speed", Range(0,20)) = 1.0
		_Freq("World wave - freq", Range(0.5, 10)) = 1.0

		_FreqL("Local wave - freq", Range(0.01, 2)) = 1.0
		_LocalNoise("Local wave - height", Range(0, 1)) = 0.1

		_LocalNoiseSpeed("Local wave - XYZ speed", Vector) = (0.0, 0.0, 0.0, 0.0)
	}

	SubShader{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "SimplexNoise3D.hlsl"

			// vertex input: position, normal
			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				fixed4 color : COLOR;
			};

			uniform fixed4 _BaseColor;
			uniform fixed4 _PeakColor;
			uniform fixed4 _TroughColor;
			uniform float _Theta;
			uniform float _Amplitude;
			uniform float _Speed;
			uniform float _Freq;
			uniform float _FreqL;
			uniform float _LocalNoise;

			uniform fixed4 _LocalNoiseSpeed;

			// scrolls through snoise, time- and space-differentiated
			float local_offset(float3 p) {
				return(snoise(p * _FreqL + _Time.y * _LocalNoiseSpeed.xyz));
			}

			// scrolls through a cosine function, time- and space-differentiated
			float global_offset(float x, float z, float space_offset) {
				float c = cos(cos(_Theta) * (x * _Freq) + sin(_Theta) * (z * _Freq) + _Time.y *_Speed + space_offset);
				return(c);
			}

			v2f vert(appdata v) {
				v2f o;

				float local_h_offset = _LocalNoise * local_offset(v.vertex.xyz);
				float global_h_offset = v.vertex.y + _Amplitude * global_offset(v.vertex.x, v.vertex.z, local_h_offset);

				v.vertex.xyz += float3(0.0, sin(global_h_offset), 0.0);
				o.pos = UnityObjectToClipPos(v.vertex);

				// float d = dot(v.vertex.xyz, normalize(float3(0.0, _PeakDot, 0.0)));
				float d = clamp(v.vertex.y, -1, 1);
				// o.color.xyz = v.normal * 0.5 + 0.5;
				if (d > 0)
					o.color.xyz = lerp(_BaseColor.xyz, _PeakColor.xyz, d);
				else
					o.color.xyz = lerp(_BaseColor.xyz, _TroughColor.xyz, 0 - d);
				o.color.w = 1.0;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target { 
				return i.color; 
			}

			ENDCG
		}
	}
}