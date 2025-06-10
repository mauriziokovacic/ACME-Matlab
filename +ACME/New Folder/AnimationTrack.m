classdef AnimationTrack < handle
    properties( Access = public, SetObservable )
        DefaultKey
        Name
    end
    
    properties( Access = public, Hidden = false )
        Data
        Track
    end
    
    methods( Access = public )
        function [obj] = AnimationTrack(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Key',              [], @(data) isnumeric(data));
            addParameter( parser, 'Time',             [], @(data) isnumeric(data));
            addParameter( parser, 'DefaultKey',       [], @(data) isnumeric(data));
            addParameter( parser, 'Name',             '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            obj.DefaultKey = parser.Results.DefaultKey;
            obj.Name       = parser.Results.Name;
            if(isempty(parser.Results.Key))
                obj.Data = containers.Map('KeyType','double','ValueType','any');
            else
                obj.Data = containers.Map(num2cell(parser.Results.Time),...
                                          num2cell(parser.Results.Key,2));
            end
            updateTrack(obj);
        end
        
        function insertKey(obj,frameTime,keyData)
            obj.Data(frameTime) = keyData;
            updateTrack(obj);
        end
        
        function [Data] = fetchTrack(obj,frameTime)
            if(isempty(obj.Data))
                Data = obj.DefaultKey;
            else
                if(obj.Data.Count == 1 )
                    Data = keyData(obj);
                else
                    k = keyData(obj);
                    Data = obj.Track({frameTime,(1:col(k))'});
                end
            end
        end
        
        function [t] = frameTime(obj)
            t = cell2mat(keys(obj.Data))';
        end
        
        function [k] = keyData(obj)
            k = cell2mat(values(obj.Data)');
        end
        
        function updateTrack(obj)
            if(obj.Data.Count > 1)
                t = frameTime(obj);
                k = keyData(obj);
                obj.Track = griddedInterpolant({t,(1:col(k))'},...
                                               k,'linear','nearest');
            end
        end
        
        function [t] = timeRange(obj)
            if(isempty(obj.Data))
                t = [Inf -Inf];
            else
                t = frameTime(obj);
                t = t([1,end])';
            end
        end
    end
    
    methods( Access = public, Static )
        function [obj] = TranslationTrack(varargin)
            obj = AnimationTrack('DefaultKey',[0 0 0],'Name','T',varargin{:});
        end
        
        function [obj] = RotationTrack(varargin)
            obj = AnimationTrack('DefaultKey',[0 0 0],'Name','R',varargin{:});
        end
        
        function [obj] = ScalingTrack(varargin)
            obj = AnimationTrack('DefaultKey',[1 1 1],'Name','S',varargin{:});
        end
    end
end