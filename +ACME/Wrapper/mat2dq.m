function [DQ] = mat2dq(T)
if(~iscell(T))
    if( col(T)== 4 )
        T = {T};
    else
        T = lin2mat(T);
    end
end
DQ = cell2mat(cellfun(@(t) helper_function(t),T,'UniformOutput',false));
end

function [DQ] = helper_function(T)
QReal = quaternion( T(1:3,1:3), 'rotmat', 'point' );
QImag = 0.5 * (quaternion([0 T(1:3,4)']) * QReal);
DQ    = [compact(QReal) compact(QImag)];
DQ    = normalized_dualquaternion(DQ);
end