void main() {
    // gl_FragColor = vec4(gl_FragCoord.xy, 1.0, 1.0);
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 particle = texture(uParticles, uv);
    particle.g += 0.0005;
    gl_FragColor = particle;
}