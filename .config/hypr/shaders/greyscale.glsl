// Grayscale
#version 300 es
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 pixColor = texture(tex, v_texcoord);

    // Luminosity method with HDR coefficients
    // https://en.wikipedia.org/wiki/Grayscale#Luma_coding_in_video_systems
    float gray = dot(pixColor.rgb, vec3(0.2627, 0.6780, 0.0593));

    vec3 grayscale = vec3(gray);
    fragColor = vec4(grayscale, pixColor.a);
}
