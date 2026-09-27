#include ../includes/simplexNoise4d.glsl

uniform float uTime;
uniform sampler2D uBase;
uniform float uDeltaTime;
uniform float uFlowFieldInfluence;
uniform float uFlowFieldStrength;
uniform float uFlowFieldFrequency;

void main() {
    // gl_FragColor = vec4(gl_FragCoord.xy, 1.0, 1.0);
    float time = uTime * 0.2;
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 particle = texture(uParticles, uv);
    vec4 base = texture(uBase, uv);

    // Reset
    if(particle.a >= 1.0) {
        particle.a = mod(particle.a, 1.0);
        particle.xyz = base.xyz;
    } else {
        // Strength of the flow field
        float strength = simplexNoise4d(vec4(base.xyz * 0.5, time + 1.0));

        float influence = (uFlowFieldInfluence - 0.5) * 2.0 * -1.0;
        strength = smoothstep(influence, 1.0, strength);

        vec3 flowField = vec3(
            simplexNoise4d(vec4(particle.xyz * uFlowFieldFrequency + 0.0, uTime)),
            simplexNoise4d(vec4(particle.xyz * uFlowFieldFrequency + 1.0, uTime)),
            simplexNoise4d(vec4(particle.xyz * uFlowFieldFrequency + 2.0, uTime))
        );

        flowField = normalize(flowField);
        particle.xyz += flowField * uFlowFieldStrength * uDeltaTime * strength;

        //Decay
        particle.a += 0.1 * uDeltaTime;
    }

    gl_FragColor = particle;
}