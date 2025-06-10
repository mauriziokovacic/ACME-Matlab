function [obj] = toggleClipping(obj,tf)
if( ischar(tf) )
    if( strcmp(tf,'on') )
        tf = true;
    else
        tf = false;
    end
end
if( tf )
    obj = obj.enableClipping();
else
    obj = obj.disableClipping();
end

end