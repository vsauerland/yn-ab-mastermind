function yn_ab_nk_mastermind( n, k )

% function yn_ab_nk_mastermind( n, k )
% codebreaker strategy for Yes-No AB mastermind with k colors and n pegs

rand( 'state', 0 );

y = randperm( k ); % secret code 
y = y( 1 : n );
x = zeros( 1, n ); % partial solution

% matrix of initial permutations:
Sigma = zeros( k, k );
Sigma( 1, : ) = 1 : k;
for i = 1 : k - 1
    Sigma( i + 1, : ) = circshift( Sigma( i, : ), [ 0, 1 ] );
end
Sigma = Sigma( :, 1 : n );

% vector with number of correct identified positions in initial permutations
v = zeros( k, 1 ); 
for r = 1 : k
    v( r ) = info( Sigma( r, : ), y );
end
count = k; % query counter

while sum( ismember( x, 0 ) ) > 0 % (while there are open positions)
    
    % 1.) determine active pair of initial queries
    r = k;
    j = r - 1;
    while ( v( r ) ~= 0 ) || ( v( j ) == 0 )
        r = r - 1;
        j = r - 1;
        if j == 0
            j = k;
        end
    end

    % findNext: bisektion to find a new correct peg
    % (right most unidentified correct position in initial query Sigma(j,:)),
    a = 1; % finally, a is a correct unidentified position in Sigma( j, : )
    b = n;
    while b > a
        l = ceil( ( a + b ) / 2 ); % current pivot position
        sigma = [ Sigma( r, 1 : l - 1 ) Sigma( j, l : n ) ];
        [ s, nlq ] = infoP( sigma, x, y );
        count = count + nlq;
        if s > 0
            a = l;
        else
            b = l - 1;
        end
    end % (bisection procedure)
  
    % 3.) expand partial solution x and update v
    x( a ) = Sigma( j, a );
    [ s, nlq ] = infoP( Sigma( j, : ), x, y );
	v( j ) = s;
    count = count + nlq;
end % (solution iteration)

fprintf( 'Code found within %i queries:\n', count );
