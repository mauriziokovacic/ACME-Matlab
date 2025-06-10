%function dump()

% clc;



% 

% display_mesh(P,N,T,[0.5 0.5 0.5]);
% hold on;

% region = skinning_regions(W);
% r = zeros(size(P,1),1);
% r(region==7)=1;
% 
% id = [10438 10439 11548 11801 11800 11798 11799 11927 11925 11751 11722 11585 11662 11565 11543 11510 11508 11505 11507 11503 11118 8700 8699 8829 10025 12860 12868 12866 12863 12858 12859 12915 12829 12736 12739 12920 12946 12949 12950 12929 12927 12926 6142 6141 6138 6140 6149 6152 12902 12850 12851 12853 12854 6145 5760 5759 5764 6144 12922 12792 12790 12852 12794 12796 12795 12803 12806 12841 12849 10430 10437 10592 10441 10438];
% id = id + 1;
% npts = numel(id);
% n = npts;
% 
% xyz = P(id,:);
% 
% order = 1;
% t = linspace(0,1,n)';
% if( id(1) == id(end) )
% %     t = vecnorm3( P(id,:)-P([id(2:end) id(1)],:) );
%     xyz = [xyz(end-1-order:end,:);xyz;xyz(2:(2+order-1),:)];
%     t = linspace(0,1,size(xyz,1))';
%     t = [linspace(-1,0,order)'; t; linspace(1,2,order)'];
% else
% %     t = vecnorm3( P(id(1:end-1),:)-P(id(2:end),:) );
%     t = [repmat(t(1),(order+1)/2,1);t;repmat(t(end),(order+1)/2,1)];
% end
% 
% % n=n-1;
% % t = linspace(0,1,size(xyz,1)+order+1)';
% % t = [zeros(order,1);t;ones(order-1,1)];
% 
% % n=n+1;
% u = linspace(0,1,n)';
% 
% Q = BSpline(xyz,t,order,u);
% % line3(Q,'LineWidth',3,'Color','red');
% % point3(Q);
% 
% % plot3(xyz(:,1),xyz(:,2),xyz(:,3),'ro','LineWidth',2);
% % text(xyz(:,1),xyz(:,2),xyz(:,3),[repmat('  ',npts,1), num2str((1:npts)')])
% % ax = gca;
% % box on
% % hold on
% % fnplt(cscvn(xyz'),'r',2);
% 
% hold on;
% L = cotangent_Laplacian(P,T);
% L = L;
% L = (speye(size(P,1))*0.0001 + L);
% L = add_constraints(L,id,[]);
% b = zeros(size(P,1),1);
% b(id) = linspace(0,1,n)';
% tmp = L \ b;
% % tmp = I;
% % tmp( region ~= 7 ) = NaN;
% % display_mesh(P,N,T,tmp);
% % p = P;
% % n = N;
% % p(region ~= 7,: ) = NaN;
% % n(region ~= 7,: ) = NaN;
% % display_mesh(P,N,T,[0.5 0.5 0.5 0.2]);
% 
% % X = BSpline(xyz,t,order, tmp);
% % hold on;
% % point3(X,50,'red','filled');




% proj =zeros(size(F,1),1);
% proj( find( DD < 0 ) ) = 1;
h = CreateViewer3D();
show = U;%  E(:,2)-E(:,1);
fig = display_mesh(P,N,T,show,'wired');
if( exist('C') )
    for c = 1 : row(C)
        if( ~isempty(C{c}) )
            display_border(C{c}.P,[],C{c}.E,'Color','r','LineWidth',1);
        end
    end
else
    display_border(P,T,FS{1},'Color','r','LineWidth',3);
end
% cmap('jet',256,16);
% setCameraPosition(P);
% axis([px(1) px(2) py(1) py(2) pz(1) pz(2)]);
fig.HandleVisibility = 'off';
rotate3d off;
% set(fig,'ButtonDownFcn',@(~, event) dummy_callback(event,P,N,T,ID,B,E,P_,N_))
set(fig,'ButtonDownFcn',@(~, event) dummy_callback(event,P,[],[],[],[],[],P_,N_))



%end