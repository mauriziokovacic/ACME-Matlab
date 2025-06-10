function [TargetHandle] = copy_properties( SourceHandle, TargetHandle, PropName )
set( TargetHandle, PropName, get( SourceHandle, PropName ) );
end