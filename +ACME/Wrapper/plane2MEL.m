function [mel] = plane2MEL(P,N)
mel = '';
for i = 1 : row(P)
    txt = ['polyPlane -axis ',num2str(N(i,:),'%f %f %f'),' -sx 2 -sy 2;',newline];
    txt = [txt,'move ',num2str(P(i,:),'%f %f %f'),';',newline];
    mel = [mel,txt];
end
end