function [P] = project_2D(P,az,el,varargin)
M = view(az,el);%viewmtx(az,el,varargin{:});
P = (M*[P ones(row(P),1)]')';
P = [P(:,1)./P(:,4),P(:,2)./P(:,4)];
end