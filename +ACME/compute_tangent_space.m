function [TG, BT] = compute_tangent_space(P,T,UV)
I = T(:,1);
J = T(:,2);
K = T(:,3);
Pi = P(I,:);
Pj = P(J,:);
Pk = P(K,:);
if( nargin < 3 )
    Ui = zeros(size(T,1),1);
    Uj = ones(size(T,1),1);
    Uk = Ui;
    Vi = Ui;
    Vj = Ui;
    Vk = Uj;
else
    Ui = UV(I,1);
    Uj = UV(J,1);
    Uk = UV(K,1);
    Vi = UV(I,2);
    Vj = UV(J,2);
    Vk = UV(K,2);
end
Q1 = Pj-Pi;
Q2 = Pk-Pi;
S1 = Uj-Ui;
S2 = Uk-Ui;
T1 = Vj-Vi;
T2 = Vk-Vi;
c = 1 ./ (S1.*T2-S2.*T1);
tg = c .* [dot([T2 -T1],[Q1(:,1) Q2(:,1)],2),...
          dot([T2 -T1],[Q1(:,2) Q2(:,2)],2),...
          dot([T2 -T1],[Q1(:,3) Q2(:,3)],2)];
bt = c .* [dot([-S2 S1],[Q1(:,1) Q2(:,1)],2),...
          dot([-S2 S1],[Q1(:,2) Q2(:,2)],2),...
          dot([-S2 S1],[Q1(:,3) Q2(:,3)],2)];
% t = normr(t);
% b = normr(b);
TG = accumarray3([I;J;K],repmat(tg,3,1));
BT = accumarray3([I;J;K],repmat(bt,3,1));
TG = normr(TG);
BT = normr(BT);
end