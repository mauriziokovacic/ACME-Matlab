function [txt] = CameraSettings()
txt = ['import torch',newline,'from ACME.math import *',newline,newline];

[P,~,T] = Octahedron();
txt = [txt,CameraFunction(P,T)];
[P,T] = subdivide(P,T,1);
txt = [txt,CameraFunction(P,T)];
[P,T] = subdivide(P,T,1);
txt = [txt,CameraFunction(P,T)];
[P,~,T] = Icosahedron();
txt = [txt,CameraFunction(P,T)];
[P,T] = subdivide(P,T,1);
txt = [txt,CameraFunction(P,T)];
end


function [txt] = CameraFunction(P,T)
txt = ['def Camera',num2str(row(P)),'(camera_distance=1):',newline];
txt = [txt,'    T = ',mat2TorchLong(T),newline];
txt = [txt,'    P = ',mat2TorchFloat(P),newline];
txt = [txt,'    P = torch.mul(normr(P),camera_distance);',newline,...
           '    P = cart2pol(P);',newline,...
           '    A = Adjacency(T).to_dense();',newline,...
           '    return P,T,A;',newline,newline];
end