// Blue Light Filter
#version 300 es
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float TEMPERATURE = 6000.0;

// Convert color temperature to RGB multiplier
vec3 getTemperatureMultiplier(float temp) {
    // Normalize temperature (1000K to 40000K range)
    float t = clamp(temp, 1000.0, 40000.0) / 100.0;

    vec3 color;

    // Red calculation
    if (t <= 66.0) {
        color.r = 1.0;
    } else {
        color.r = clamp(1.292936186 * pow(t - 60.0, -0.1332047592), 0.0, 1.0);
    }

    // Green calculation
    if (t <= 66.0) {
        color.g = clamp(0.390081579 * log(t) - 0.631841444, 0.0, 1.0);
    } else {
        color.g = clamp(1.129890861 * pow(t - 60.0, -0.0755148492), 0.0, 1.0);
    }

    // Blue calculation
    if (t >= 66.0) {
        color.b = 1.0;
    } else if (t <= 19.0) {
        color.b = 0.0;
    } else {
        color.b = clamp(0.543206789 * log(t - 10.0) - 1.196254089, 0.0, 1.0);
    }

    return color;
}

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 tempMultiplier = getTemperatureMultiplier(TEMPERATURE);

    vec3 filteredColor = pixColor.rgb * tempMultiplier;
    fragColor = vec4(filteredColor, pixColor.a);
}
