classdef Region < handle
    properties
        V
        T
        C
        R
    end
    
    methods
        function [obj] = Region(T,W,C)
            obj.R = repmat(struct('VID',[],'TID',[],'CID',[]),col(W),1);
            obj.V = repmat(struct('ID',[]),row(W),1);
            obj.T = repmat(struct('ID',[]),row(T),1);
            obj.C = repmat(struct('ID',[]),row(C.CData),1);
            
            W = vertex2face(W,T);
            for r = 1 : col(W)
                t = find(W(:,r));
                v = unique(T(t,:));
                obj.R(r).VID = v;
                obj.R(r).TID = t;
                for i = 1 : numel(v)
                    obj.V(v(i)).ID = [obj.V(v(i)).ID;r];
                end
                for i = 1 : numel(t)
                    obj.T(t(i)).ID = [obj.T(t(i)).ID;r];
                end
            end
            for c = 1 : row(C.CData)
                w = C.CData(c).average('Weight');
                r = find(w);
                for i = 1 : numel(r)
                    obj.R(r(i)).CID = [obj.R(r(i)).CID;c];
                end
                obj.C(c).ID = r;
            end
        end
        
        
    end
end