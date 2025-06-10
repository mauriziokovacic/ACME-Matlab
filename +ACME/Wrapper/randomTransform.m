function [T] = randomTransform(type)
if(nargin<1)
    type = 'trs';
end
t = randn(1,3);
r = randn(1,3) * pi;
s = randn(1,3);
s(s==0) = 1;
M = {};
type = lower(type);
if(contains(type,'t'))
    M = [M;...
        {Tra3([t(1) 0 0],'matrix');...
         Tra3([0 t(2) 0],'matrix');...
         Tra3([0 0 t(3)],'matrix')}];
end
if(contains(type,'r'))
    M = [M;...
        {RotX(      r(1),'matrix');...
         RotY(      r(2),'matrix');...
         RotZ(      r(3),'matrix')}];
end
if(contains(type,'s'))
    M = [M;...
        {Sca3([s(1) 1 1],'matrix');...
         Sca3([1 s(2) 1],'matrix');...
         Sca3([1 1 s(3)],'matrix')}];
end
M = M(randperm(numel(M)));
T = eye(4);
for i = 1 : numel(M);
    T = M{i} * T;
end
end