function createVideo( path, P, N, T, Fold, FoldSet, Geodesic, Influence, Flow, P_, N_ )
[h, ax, l] = CreateViewer3D('right');
h.WindowButtonMotionFcn = [];

id = unique([FoldSet(:,1);FoldSet(:,2)]);

[M,m] = bounding_box(P);
s = norm(M-m)/10;

set(h,'Units','Normalized');
set(h,'OuterPosition',[0 0 1 1]);


duration = 100 * ones(6,1);
theta = 30;
for phase = 1 : 6
    switch phase
        case 1
            descr = 'Original Mesh';
        case 2
            descr = 'Fold Function';
        case 3
            descr = 'Fold Set';
        case 4
            descr = 'Distance from Fold Set';
        case 5
            descr = 'Fold Influence';
        case 7
            descr = 'Deformation Flow';
        case 6
            descr = 'Contact Planes';
    end
    
    thetas = linspace(theta,theta-360,duration(phase));
    
    vidObj = VideoWriter([path,num2str(phase-1),'.mp4'],'MPEG-4');
    vidObj.Quality = 100;
    vidObj.open;
    
    for theta = thetas(1:end)
        clf(h);
        axes( h, ...
            'Color','none',...
            'Box','off',...
            'XColor','none',...
            'YColor','none',...
            'ZColor','none',...
            'XGrid','off',...
            'YGrid','off',...
            'ZGrid','off',...
            'GridLineStyle','none',...
            'XTick',[],...
            'YTick',[],...
            'ZTick',[],...
            'XMinorTick','off',...
            'YMinorTick','off',...
            'ZMinorTick','off',...
            'Clipping','off');
        l = light('Position',[0.2 -0.2 1]);
        axis vis3d;
        axis tight;
        view(0,90);
        switch phase
            case 1
                display_mesh(P,N,T);
                cmap('parula');
            case 2
                display_mesh(P,N,T,Fold);
                cmap('parula');
            case 3
                display_mesh(P,N,T,Fold);
                display_border(P,T,FoldSet,'Color','r','LineWidth',3);
                cmap('parula');
            case 4
                display_mesh(P,N,T,1-Geodesic);
                cmap('parula');
            case 5
                display_mesh(P,N,T,Influence);
                cmap('parula');
            case 7
                display_mesh(P,N,T,Influence);
                cmap('parula');
                hold on;
                quiv3(P,Flow,'Color','w');
            case 6
                display_mesh(P,N,T);
                hold on;
                plane3(P_(id,:),N_(id,:),[],0.2*s,[1 1 0]);
        end
        colorbar;
        camorbit(0,theta);
%         title(descr);
        drawnow;
        vidObj.writeVideo(getframe(h));
        vidObj.writeVideo(getframe(h));
        vidObj.writeVideo(getframe(h));
    end
    
    vidObj.close;
end

end