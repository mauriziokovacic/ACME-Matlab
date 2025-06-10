function [obj] = from_GEO(obj,filename)
[ P, UV, N, T ] = import_GEO(filename);
obj = Mesh(P,N,UV,T);
end

