function [ yn, nlq ] = infoP( sigma, x, y )
%YN_INFO2 indicates if a guess has correct yet unidentified components
%
% yn = infoP( sigma, j , x )
%
% sigma: guess
% x:     partial solution vector
% y:     secret code
%
% yn:    indicator if sigma has some correct yet unidentified component
% nlq:   number of local queries that are necessary to determine yn
%        nlq = 2   if sigma coincides with x in one component
%                  and all other x-components are zero
%              1   else

if  nargin ~= 3
    error( 'INFOP: three input arguments required' );
end
n = length( sigma );
if ( n ~= length( y ) || n ~= length( x ) )
    error( 'INFOP: all arguments must have the same length' );
end

cardX = length( x( x ~= 0 ) ); % number of identified components
cardSX = length( x( x == sigma ) ); % number of coincidences between x and sigma

if cardSX == 0 % if sigma does not coincide with x, a single query suffices
    yn = info( sigma, y ); 
    nlq = 1;
else
    if cardSX > 1 
        % derangement of the correct identified pegs of sigma
    	rho = sigma;
        w = x( x == rho );
        w = circshift( w, 1 );
        rho( rho == x ) = w;
        yn = info( rho, y );
        nlq = 1;
    else % ( cardSX == 1 )
        i = find( x == sigma ); % ought to be a single integer
        if cardX > 1
            % in sigma, swap the unique correct identified peg
            % with the wrong peg at some other "identified position"
	        rho = sigma;
            j = find( x ~= 0 & x ~= x( i ), 1 ); % ought to exist
            rho( [ i j ] ) = rho( [ j i ] );
            yn = info( rho, y );
            nlq = 1;
        else % ( cardX == 1 )
            % swap peg i with two neighbours
            % there is no correct yet unidentified peg in sigma
            % if and only if both swaps yield answer "no"
            yn = 0;
            for k = i + 1 : i + 2
                j = k;
                if j > n
                    j = j - n;
                end
                rho = sigma;
            	rho( [ i j ] ) = rho( [ j i ] );
                if info( rho, y ) == 1
                    yn = 1;
                end
            end
            nlq = 2;
	    end
    end
end
