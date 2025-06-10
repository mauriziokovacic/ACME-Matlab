classdef CurvaturePlugin < AbstractPlugin
    methods
        function [obj] = CurvaturePlugin(varargin)
            obj@AbstractPlugin(varargin{:});
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.buildInputData('MeshData');
            obj.buildOutputData('CurvatureData',{'H','K','k1','k2'});
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('Compute');
            menu  = uimenu(menu,'Text','Curvature');
            mitem = uimenu(menu,'Text','Export Data');
            uimenu(mitem,'Text','To Workspace...','MenuSelectedFcn',@(varargin) obj.exportData('ws'));
            uimenu(mitem,'Text','To file...','MenuSelectedFcn',@(varargin) obj.exportData('f'));
            mitem = uimenu(menu,'Text','Mean','Separator','on');
            mitem.MenuSelectedFcn = @obj.computeMean;
            mitem = uimenu(menu,'Text','Gaussian');
            mitem.MenuSelectedFcn = @obj.computeGauss;
            mitem = uimenu(menu,'Text','k1');
            mitem.MenuSelectedFcn = @obj.computek1;
            mitem = uimenu(menu,'Text','k2');
            mitem.MenuSelectedFcn = @obj.computek2;
        end
        
        function exportData(obj,type)
            switch type
                case 'ws'
                    prompt = {'Enter Workspace name:',...
                      'Enter Mean (H) name:',...
                      'Enter Gaussian (K) name:',...
                      'Enter Min (k1) name:',...
                      'Enter Max (k2) name:'};
                    title = 'Export Curvature to Workspace...';
                    dims = [1 35];
                    definput = {'base','H','K','k1','k2'};
                    input = inputdlg(prompt,title,dims,definput);
                    if(~isempty(input))
                        pn = properties(obj.Output);
                        for i = 1 : numel(pn)
                            if(~isempty(input{i+1}))
                                assignin(input{1},input{i+1},obj.Output.(pn{i}));
                            end
                        end
                    end
                case 'f'
                    disp('Feature not availble yet');
            end
%             propname = properties(obj.Output);
%             out = [];
%             for i = 1 : numel(propname)
%                 out.(propname{i}) = obj.Output.(propname{i});
%             end
%             assignin('base',strcat(class(obj),'Output'),out);
        end
    end
    
    methods( Access = private )
        function [obj] = computeMean(obj,varargin)
            P = obj.Input.Vertex;
            T = obj.Input.Face;
            obj.Output.H = mean_curvature(P,T);
            h = obj.Input.Handle;
            DisplayScalarFunction(h,obj.Output.H);
        end
        
        function [obj] = computeGauss(obj,varargin)
            P = obj.Input.Vertex;
            T = obj.Input.Face;
            obj.Output.K = gaussian_curvature(P,T);
            h = obj.Input.Handle;
            DisplayScalarFunction(h,obj.Output.K);
        end
        
        function [obj] = computek1(obj,varargin)
            P = obj.Input.Vertex;
            T = obj.Input.Face;
            obj.Output.k1 = min_curvature(P,T);
            h = obj.Input.Handle;
            DisplayScalarFunction(h,obj.Output.k1);
        end
        
        function [obj] = computek2(obj,varargin)
            P = obj.Input.Vertex;
            T = obj.Input.Face;
            obj.Output.k2 = max_curvature(P,T);
            h = obj.Input.Handle;
            DisplayScalarFunction(h,obj.Output.k2);
        end
    end
end