function dummy_callback(event,P,N,T,ID,B,E,P_,N_)
W_ = evalin('base','W_');
F  = evalin('base','F');
% id_ = evalin('base','id_');
% G = evalin('base','G');
persistent pth pln qui;
if( ~isempty(pth) )
    delete(pth);
end
if( ~isempty(pln) )
    delete(pln);
end
if( ~isempty(qui) )
    delete(qui);
end
p = event.IntersectionPoint;
p = sum((p-P).^2,2);
[~,i] = min(p);
% [p,u]=extract_path(P,N,T,ID,B,E(i,:));
hold on;
pth = line3([P(i,:);P_(i,:)],'LineWidth',6);%pth = path3(p);%%
hold on;
[M,m] = bounding_box(P);
s = norm(M-m)/10;
pln = plane3(P_(i,:),N_(i,:),3*s,[1 1 0 0.5]);
pln.HitTest = 'off';
pln.PickableParts = 'none';
hold on;
% qui = quiv3(P_(i,:)+u(end,:),N_(i,:));
hold off;
disp(['ID: ', num2str(i), ' F: ', num2str(F(i,1)), ' #: ', num2str(size(p,1)), ' W: ', num2str(W_(i,:))]);
end