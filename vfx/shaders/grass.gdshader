shader_type spatial;
render_mode cull_disabled;

uniform vec3 color : source_color;
uniform vec3 color2 : source_color;
uniform sampler2D noise;
uniform float noiseScale;

uniform sampler2D windNoise;
uniform float windScale;
uniform float windSpeed;
uniform float windStrength;

varying vec3 worldPos;


void vertex() {
	worldPos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 wind = ((texture(noise, worldPos.xz / noiseScale + TIME * windSpeed).rgb - 0.5) * windStrength) * vec3(1,0,1) *  (1.0 - UV.y);
	VERTEX += wind;
}

void fragment() {
	vec3 noiseLevel = texture(noise, worldPos.xz / noiseScale).rgb;
	ALBEDO = mix(color, color2, UV.y) * mix(color, color2, noiseLevel.r);
	
	if(!FRONT_FACING) NORMAL = -NORMAL;
}
