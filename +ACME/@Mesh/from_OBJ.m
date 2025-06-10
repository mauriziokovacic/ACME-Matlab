function [obj] = from_OBJ(obj,filename)
[ P, N, UV, T ] = import_OBJ(filename);
obj = Mesh(P,N,UV,T);
end

