function [u,data] = padinterp1(u,data,k)
u    = [u(end-k:end),u,u(1:k)];
data = [data(end-k:end,:);data;data(1:k,:)];
end