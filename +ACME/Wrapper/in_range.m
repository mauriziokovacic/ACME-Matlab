function [tf] = in_range(Value,Min,Max)
    tf = logical(prod((Value>=Min)&(Value<=Max),2));
end