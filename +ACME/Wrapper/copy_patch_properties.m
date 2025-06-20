function [TargetHandle] = copy_patch_properties( SourceHandle, TargetHandle )
PropName = properties(SourceHandle);
PropName(false...
        |strcmpi(PropName,'BeingDeleted')...
        |strcmpi(PropName,'Type')...
        |strcmpi(PropName,'Annotation')...
        |strcmpi(PropName,'XData')...
        |strcmpi(PropName,'YData')...
        |strcmpi(PropName,'ZData')...
        ) = [];
TargetHandle = copy_properties(SourceHandle,TargetHandle,PropName);
end