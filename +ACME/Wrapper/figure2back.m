function figure2back()
f = findobj('Type','figure');
if(isempty(f))
    return;
end
arrayfun(@(fig) uistack(fig,'bottom'),f);
end