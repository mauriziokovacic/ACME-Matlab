function [t] = curve2param(P)
i = (1:row(P)-1)';
j = (2:row(P)  )';
t = cumsum([0;distance(P(i,:),P(j,:))]);
t = t/t(end);
end