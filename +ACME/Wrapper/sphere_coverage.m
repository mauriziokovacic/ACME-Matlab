function [P] = sphere_coverage(nsamples)
    i    = (0:nsamples-1)';
    phi  = i./sqrt(3);
    phi  = (phi-floor(phi))*2*pi;
    cosT = (i*2+1)/nsamples-1;
    sinT = sqrt(clamp(1-cosT.^2,0,1));
    P    = [cos(phi).*sinT, sin(phi).*sinT, cosT];
end