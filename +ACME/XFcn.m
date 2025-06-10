function [alpha] = XFcn(P,S,d)


num = zeros(row(P{1}),1);
den = num;

for i = row(P)
    num = num + sum(d{i}.*(S{i,1}-P{i,1}),2);
    den = den + sum(d{i}.^2,2);
end

alpha = num./den;

% X     = S-P;
% alpha = sum(d.*X,2)./sum(d.^2,2);


alpha(~isfinite(alpha)) = 0;
end