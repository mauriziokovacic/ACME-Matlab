function setCameraPosition(P)
persistent O U V W m M s;
% set( gca, 'Xdir', 'reverse' );
% set( gca, 'Ydir', 'reverse' );
% set( gca, 'Zdir', 'reverse' );

if( isempty(O) )
[O,U,V,W] = PCA(P);
[m,M] = bounding_box(P);
s = norm(m-M);
end
set( gca, 'Clipping', 'off' );
set( gca, 'CameraPosition', O+V*s+W*s);
set( gca, 'CameraTarget', O);
set( gca, 'CameraUpVector', -U );
view(0,0);
camlight(180,0);
camlight(0,0);

box off;
grid off;
axis vis3d;
axis tight;
rotate3d on;

end