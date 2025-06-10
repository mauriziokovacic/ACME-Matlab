classdef Chronometer < handle
    properties( Access = private, Hidden = true )
        running
    end
    
    properties( Access = public )
        stopped
    end
    
    methods( Access = public )
        function [obj] = Chronometer(varargin)
            obj.stopped = table('Size',         [0 1],...
                                'VariableTypes',{'double'},...
                                'VariableNames',{'Time'});
            obj.running = table('Size',         [0 1],...
                                'VariableTypes',{'uint64'},...
                                'VariableNames',{'Time'});
            for i = 1 : 2 : nargin-1
                obj.insert_clock_timing(varargin{i},varargin{i+1});
            end
        end
        
        function [obj] = start_clock(obj,Name)
            obj.running(capital(Name),:) = {tic};
        end
        
        function [obj] = stop_clock(obj,Name)
%             Name = capital(Name);
            if( obj.contains_running_clock(Name) )
                obj.stopped(Name,:) = {toc(obj.running{Name,:})};
                obj.running(Name,:) = [];
            end
        end
        
        function [T] = clock_time(obj,Name)
%             Name = capital(Name);
            if( obj.is_clock_running(Name) )
                T = toc(obj.running{Name,:});
            else
                T = obj.stopped{Name,:};
            end
        end
        
        function [tf] = is_clock_running(obj,Name)
            tf = false;
            if( obj.contains_running_clock(Name) )
                tf = true;
            end
        end
        
        function [tf] = is_clock_stopped(obj,Name)
            tf = false;
            if( obj.contains_stopped_clock(Name) )
                tf = true;
            end
        end
        
        function [tf] = contains_clock(obj,Name)
            tf = obj.contains_running_clock(Name) || obj.contains_stopped_clock(Name);
        end
        
        function [obj] = insert_clock_timing(obj,Name,Value)
%             Name = capital(Name);
            if(nargin<3)
                Value = NaN;
            end
            obj.stopped(Name,:) = {Value};
        end
        
        function [T] = total_time(obj)
            T = sum(obj.stopped{:,1});
        end
        
        function [T] = min_time(obj)
            T = min(obj.stopped{:,1});
        end
        
        function [T] = average_time(obj)
            T = mean(obj.stopped{:,1});
        end
        
        function [T] = meadian_time(obj)
            T = median(obj.stopped{:,1});
        end
        
        function [T] = max_time(obj)
            T = max(obj.stopped{:,1});
        end
        
        function [txt] = to_string(obj)
            txt = char(cellfun(@(r) char(strcat(r,{' time: '},num2str(obj.stopped{r,1}))),...
                               obj.stopped.Row,...
                               'UniformOutput',false));
        end
        
        function show(obj)
            obj.stopped
        end
        
    end
    
    methods( Access = private, Hidden = true )
        function [tf] = contains_running_clock(obj,Name)
            tf = ~isempty(find(cellfun(@(r) strcmp(r,Name), obj.running.Row),1));
        end
        
        function [tf] = contains_stopped_clock(obj,Name)
            tf = ~isempty(find(cellfun(@(r) strcmp(r,Name), obj.stopped.Row),1));
        end
    end
end