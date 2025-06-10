function [u,v,data] = padinterp2(u,v,data,k)
% u = [u(1)-(u(end)-u(end-k:end-1)),u,u(end)+(u(2:1+k)-u(1))];
v = [v(1)-(v(end)-v(end-k:end-1)),v,v(end)+(v(2:1+k)-v(1))];
% data = [repmat(data(1,:),k,1);data;repmat(data(end,:),k,1)];
data = [data(:,end-k:end-1,:),data,data(:,2:1+k,:)];
end