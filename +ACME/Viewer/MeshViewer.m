classdef MeshViewer < handle
    properties( Access = private )
        mesh
    end
    
    properties( Access = public )
        P % points
        N % normals
        T % polygons
        C % colors
        F % scalar function
        M % material
        
        RenderMode  % points, wireframe, wired, solid
        ShadingMode % flat, phong
        AOMode      % Ambient occlusion
    end
    
    methods
        function update(obj)
            delete(obj.mesh);
            draw(obj);
        end
    end
    
    methods(Access = private)
        function [I] = computeAO(obj)
            ax = get(obj.mesh,'Parent');
            D  = repmat(normr(ax.CameraPosition-ax.CameraTarget),row(obj.N),1);
            I  = clamp(dot(D,obj.N,2),0,1);
        end
    end
end