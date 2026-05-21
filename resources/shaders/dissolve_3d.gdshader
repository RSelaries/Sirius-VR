shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

group_uniforms dissolve;
uniform float dissolve_amount: hint_range(0.0, 1.0, 0.001);
uniform sampler2D dissolve_texture: source_color, filter_linear_mipmap, repeat_enable;

group_uniforms albedo;
uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

group_uniforms rougness;
uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

group_uniforms metallic;
uniform float metallic : hint_range(0.0, 1.0, 0.01);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform float specular : hint_range(0.0, 1.0, 0.01) = 0.5;

group_uniforms normal;
uniform sampler2D texture_normal : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float normal_scale : hint_range(-16.0, 16.0) = 1.0;

group_uniforms ambiant_occlusion;
uniform sampler2D texture_ambient_occlusion : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform float ao_light_affect : hint_range(0.0, 1.0, 0.01);

group_uniforms triplanar_and_uv;
uniform bool triplanar = false;
uniform float uv1_blend_sharpness : hint_range(0.0, 150.0, 0.001) = 1.0;
uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset;

varying vec3 uv1_triplanar_pos;
varying vec3 uv1_power_normal;

void vertex() {
	vec3 normal = NORMAL;

	TANGENT = vec3(0.0, 0.0, -1.0) * abs(normal.x);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.y);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.z);
	TANGENT = normalize(TANGENT);

	BINORMAL = vec3(0.0, 1.0, 0.0) * abs(normal.x);
	BINORMAL += vec3(0.0, 0.0, -1.0) * abs(normal.y);
	BINORMAL += vec3(0.0, 1.0, 0.0) * abs(normal.z);
	BINORMAL = normalize(BINORMAL);

	// UV1 Triplanar: Enabled
	uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
	vec4 samp = vec4(0.0);
	samp += texture(p_sampler, p_triplanar_pos.xy) * p_weights.z;
	samp += texture(p_sampler, p_triplanar_pos.xz) * p_weights.y;
	samp += texture(p_sampler, p_triplanar_pos.zy * vec2(-1.0, 1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	// Albedo
	vec4 albedo_tex = texture(texture_albedo, UV);
	if(triplanar) albedo_tex = triplanar_texture(texture_albedo, uv1_power_normal, uv1_triplanar_pos);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	
	// Metallic
	float metallic_tex = texture(texture_metallic, UV).r;
	if(triplanar) metallic_tex = triplanar_texture(texture_metallic, uv1_power_normal, uv1_triplanar_pos).r;
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;
	
	// Rougness
	float roughness_tex = texture(texture_roughness, UV).r;
	if(triplanar) roughness_tex = triplanar_texture(texture_roughness, uv1_power_normal, uv1_triplanar_pos).r;
	ROUGHNESS = roughness_tex * roughness;

	// Normal Map
	vec3 normal_tex = texture(texture_normal, UV).rgb;
	if(triplanar) normal_tex = triplanar_texture(texture_normal, uv1_power_normal, uv1_triplanar_pos).rgb;
	NORMAL_MAP = normal_tex;
	NORMAL_MAP_DEPTH = normal_scale;

	// Ambient Occlusion
	float ao_tex = texture(texture_ambient_occlusion, UV).r;
	if(triplanar) ao_tex = triplanar_texture(texture_ambient_occlusion, uv1_power_normal, uv1_triplanar_pos).r;
	AO = ao_tex;
	AO_LIGHT_AFFECT = ao_light_affect;
	
	// Dissolve effect
	float sample = texture(dissolve_texture, UV + vec2(TIME * 0.05)).r;
	float emission_value = 1.0 - smoothstep(dissolve_amount, dissolve_amount, sample);
	ALPHA = smoothstep(dissolve_amount, dissolve_amount, sample);
}
