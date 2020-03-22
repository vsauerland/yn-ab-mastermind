function yn = yn_info( w, y )

% yn = yn_info( w, y )
% indicates if w and y coincide in some component
% w, y: vectors of same length
% yn: 1 if w and y coincide in some component
%     0 else

yn = 0;
if  nargin ~= 2
    error( 'INFO: two input arguments of same length required' );
end
if length( w ) ~= length( y )
    error( 'INFO: input arguments must have the same length');
end
n = sum( w == y );
if n > 0
    yn = 1;
end
