
Uniform
{
	u_WorldMatrix WORLD_MATRIX
	u_ViewMatrix VIEW_MATRIX
	u_ProjMatrix PROJ_MATRIX

	u_CameraPos FLOAT3
	u_LightDir FLOAT3
	u_Emissive FLOAT3
	u_Ambient FLOAT3
	u_Diffuse FLOAT3
	u_Specular FLOAT3
	u_SpecularPower FLOAT1
}

VertexShader {

	attribute vec4 POSITION;
	attribute vec4 NORMAL;
	attribute vec4 COLOR;

	varying vec4 v_color;

	uniform mat4 u_WorldMatrix;
	uniform mat4 u_ViewMatrix;
	uniform mat4 u_ProjMatrix;

	uniform vec3 u_CameraPos;
	uniform vec3 u_LightDir;
	uniform vec3 u_Emissive;
	uniform vec3 u_Ambient;
	uniform vec3 u_Diffuse;
	uniform vec3 u_Specular;
	uniform float u_SpecularPower;

	void main()
	{
		// 世界变换
		gl_Position = u_WorldMatrix * POSITION;
		vec4 worldNormal = u_WorldMatrix * NORMAL;

		// 计算光照
		vec3 P = gl_Position.xyz;
		vec3 N, L, V, H;
		float kd, ks, ka;

		N = worldNormal.xyz;
		L = u_LightDir;
		V = u_CameraPos - P;
		V = normalize(V);
		H = L + V;
		H = normalize(H);

		kd = max(dot(N, L), 0.0);
		ks = max(dot(N, H), 0.0);
		ks = pow(ks, u_SpecularPower);
		ka = 1.0;

		v_color.rgb = u_Emissive + (u_Ambient + (u_Diffuse * kd + u_Specular * ks) * ka);
		v_color.a = COLOR.a;

		// 相机变换
		gl_Position = u_ViewMatrix * gl_Position;

		// 投影变换
		gl_Position = u_ProjMatrix * gl_Position;
	}

}

PixelShader {

	varying vec4 v_color;

	void main()
	{
		gl_FragColor = v_color;
	}

}