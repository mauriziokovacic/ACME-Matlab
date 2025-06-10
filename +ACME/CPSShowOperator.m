function CPSShowOperator( Op )
if( nargin == 0 )
    error('No grid provided');
end

if( ~isa( Op, 'CPSOperator' ) )
    error('Input is not a valid CPSOperator');
end

CPSOperatorViewer( Op );
end
