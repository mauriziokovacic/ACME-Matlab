function figure2front()
f = findobj('Type','figure');
if(isempty(f))
    return;
end
arrayfun(@(fig) uistack(fig,'top'),f);
end