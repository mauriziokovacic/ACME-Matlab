function [Fi] = phi_i(W)
Fi = sqrt(min(W,1-W).^2./max(W,1-W).^2);
end