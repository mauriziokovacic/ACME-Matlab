function [P_,N_,W_,U] = compute_contact(P,T,Curve)
CData = compute_data(P,T,Curve);
I     = closest_curve(CData);
P_    = zeros(size(P));
N_    = zeros(size(P));
W_    = cell(row(P),1);
U     = zeros(row(P),1);
for i = 1 : row(P)
    P_(i,:) = CData{I(i)}.P(i,:);
    N_(i,:) = CData{I(i)}.N(i,:);
    W_{i}   = CData{I(i)}.W(i,:);
    U(i)    = CData{I(i)}.U(i);
end
W_ = cell2mat(W_);
N_ = reorient_plane(P_,N_,P);
end

function [val] = solver(L,onIndex,onValue,offIndex,offValue)
val             = zeros(L.MatrixSize(1),col(onValue));
val(offIndex,:) = repmat(offValue,numel(offIndex),1);
val( onIndex,:) = onValue;
val             = L\val;
end

function [index] = constraints(T,Curve)
index = [];
for c = 1 : row(Curve)
i = getIndex(T,Curve{c});
index = [index;i];
end
index = unique(index);
end

function [i] = getIndex(T,Curve)
i = unique(T(Curve.T,:));
end

function [U,P,N,W] = curve_data(T,L,Curve,i,constr)
U = solver(L,i,1,setdiff(constr,i),0);

[I,J,K] = tri2ind(T(Curve.T,:));
n = accumarray([I;J;K],1,[L.MatrixSize(1) 1]);

v = accumarray3([I;J;K],repmat(Curve.P,3,1),[L.MatrixSize(1) 1])./n;
P = solver(L,i,v(i,:),setdiff(constr,i),mean(Curve.P));

v = accumarray3([I;J;K],repmat(Curve.N,3,1),[L.MatrixSize(1) 1])./n;
N = solver(L,i,v(i,:),setdiff(constr,i),mean(Curve.N));

v = accumarrayN([I;J;K],repmat(Curve.W,3,1),[L.MatrixSize(1) 1])./n;
W = solver(L,i,v(i,:),setdiff(constr,i),mean(Curve.W));
end

function [CurveData] = compute_data(P,T,Curve)
CurveData = cell(row(Curve),1);
constr = constraints(T,Curve);
L = cotangent_Laplacian(P,T);
L = add_constraints(L,constr,[]);
L = decomposition(0.0001 * speye(row(L),col(L)) + L);
for c = 1 : row(Curve)
    i = getIndex(T,Curve{c});
    [U,P,N,W] = curve_data(T,L,Curve{c},i,constr);
    CurveData{c} = struct('U',U,'P',P,'N',N,'W',W);
end
end

function [I] = closest_curve(CurveData)
U = cellfun(@(c) c.U,CurveData,'UniformOutput',false)';
U = cell2mat(U);
[~,I] = sort(U,2,'descend');
I = I(:,1);
end