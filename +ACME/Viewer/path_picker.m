function path_picker(P,N,T,verbose,varargin)%ID,B,E,verbose)
if( isempty(verbose) )
    verbose = false;
end
fig  = CreateViewer3D();
mesh = display_mesh(P,zeros(size(P)),T,[0.5 0.5 0.5],'wired');
mesh.HandleVisibility = 'off';
set(mesh,'ButtonDownFcn',@(object,event) path_picker_handler(object,event,P,N,T,verbose,varargin{:}));
end

function path_picker_handler(object,event,P,N,T,verbose,varargin)
persistent KDTree;
persistent lines;
delete(lines);
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
i = knnsearch(KDTree,event.IntersectionPoint,'K',1);
if( numel(varargin)==1 )
    Q = cell2mat(varargin{1}(i));
else
    Q = extract_path(P,N,T,varargin{1},varargin{2},varargin{3}(i,:));
end
hold on;
lines = path3(Q);
hold off;
if( verbose )
    disp(strcat('ID  : ', num2str(i)));
    disp(strcat('Hops: ', num2str(abs(E(i,1)-E(i,2)))));
end
end