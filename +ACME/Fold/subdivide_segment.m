function [S] = subdivide_segment(S)
for i = 1 : row(S)
    if(isempty(S{i}))
        continue;
    end
    s = S{i};
    C = 0.5.*(s.A+s.B);
    s.A = interleave(s.A,C);
    s.B = interleave(C,s.B);
    s.T = repelem(s.T,2,1);
    S{i} = s;
end
end