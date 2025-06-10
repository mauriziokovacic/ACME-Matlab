clear all; clc;


[ P, UV, N, E, T, S ] = import_Mesh( 'Data/Jeff' );

f   = figure;
display_mesh( P, N, T );
ax1 = f.CurrentAxes;
title('Linear Blend Skinning')

f   = figure;
display_mesh( P, N, T );
ax2 = f.CurrentAxes;
title('Dual Quaternion Skinning')

f   = figure;
display_mesh( P, N, T );
ax3 = f.CurrentAxes;
title('Implicit Skinning')

f   = figure;
display_mesh( P, N, T );
ax4 = f.CurrentAxes;
title('Contact Plane Skinning')

linkprop([ax1,ax2,ax3,ax4],...
         {'CameraPosition',...
         'CameraTarget',...
         'CameraViewAngle',...
         'CameraUpVector',...
         'XLim',...
         'YLim',...
         'ZLim' });
rotate3d on;

