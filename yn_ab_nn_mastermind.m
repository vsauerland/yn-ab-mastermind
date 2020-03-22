function yn_ab_nn_mastermind( n )

% function yn_ab_nn_mastermind( n )
% codebreaker algorithmus for Yes-No AB-Mastermind with n holes and n colors

rand( 'state', 0 );

y = randperm( n ) % hidden permutation 
x = zeros( 1, n ); % partial solution

% matrix of initial permutations:
Sigma = zeros( n, n );
Sigma( 1, : ) = 1 : n;
for i = 1 : n - 1
    Sigma( i + 1, : ) = circshift( Sigma( i, : ), [ 0, 1 ] );
end

% vector v indicates for each initial permutation,
% if it contains a correct (unidentified) component
v = zeros( n, 1 ); 
for r = 1 : n
    v( r ) = info( Sigma( r, : ), y );
end
count = n; % query counter

while sum( ismember( x, 0 ) ) > 1 % (while there are unidentified positions)
    
    % determine active pair of initial permutations and pivot element
    r = n;
    j = r - 1;
    while ( v( r ) ~= 0 ) || ( v( j ) == 0 )
        r = r - 1;
        j = r - 1;
        if j == 0
            j = n;
        end
    end
   
    if ( count == n )
        % find the first correct position
        % (left most correct position in Sigma( r, : ))
        % here, we apply binary search
        a = 1; % left interval limit
        b = n; % right interval limit
        l = floor( ( n + 1 ) / 2 ); % current pivot position
        % final b will be the correct position in Sigma( r, : )
        while b > a
            c = Sigma( r, 1 );
            sigma = [ Sigma( r, 2 : l ) c Sigma( r, l + 1 : n ) ];
            s = info( sigma, y );
            count = count + 1;
            if ( s == 1 )
                % we need to check wether the pivot peg is correct
                % since in that case there is no correct peg to the left
                % of the pivot peg in Sigma( r, : )
                if ( l < n )
                    rho = [ Sigma( r, 2 : l + 1 ) c Sigma( r, l + 2 : n ) ];
                else
                    rho = [ c Sigma( r, 3 : l ) Sigma( r, 2 ) ];
                end
                s = info( rho, y );
                count = count + 1;
            end
            if ( s > 0 ) % && r > 0 )
                % left to position l is some correct peg in Sigma( r, : )
                b = l - 1;
            else
                a = l;
            end
            % bisection step (new pivot peg position)
            if l == a && b == a + 1
                l = b;
            else
                l = floor( ( a + b ) / 2 );
            end
        end % (bisection procedure)
        pivot = y( b ); % using this first identified color for the rest

    else % findNext
        % pivot positions in permutations r und j
        lr = pivot + r - 1;
        if lr > n
            lr = lr - n;
        end
        if lr == 1
            lj = n;
        else
            lj = lr - 1;
        end

        % initial step for the bisection to find another correct position
        % (left most unidentified correct position in Sigma( r, : )):
        % test whether there are correct pegs between positions lj + 1 and n
        % in permutation j
        if lj == n
            direction = -1;
        else
            sigma = [ pivot Sigma( j, 1 : lj - 1 ) Sigma( j, lj + 1 : n ) ];
            [ s, nlq ] = infoP( sigma, x, y );
            count = count + nlq;
            if s > 0
                direction = 1; % bisection in the interval [1:lj]
            else    
                direction = -1; % bisection in the intervall [lr:n]
            end
        end
        if direction == -1
            a = 1; % left interval limit
            b = lj; % right interval limit
        else
            a = lr; % left interval limit
            b = n; % right interval limit
        end
        % final b will be the correct position in Sigma( r, : )
        l = floor( ( a + b ) / 2 ); % current pivot position
	% actual bisection loop
        while b > a
            if direction == -1
                sigma = [ Sigma( j, 1 : l - 1 ) pivot Sigma( r, l + 1 : lj ) Sigma( j, lj + 1 : n ) ];
            else
                sigma = [ Sigma( r, 1 : lr - 1 ) Sigma( j, lr : l - 1 ) pivot Sigma( r, l + 1 : n ) ];
            end
            [ s, nlq ] = infoP( sigma, x, y );
            count = count + nlq;
            if s > 0
                % left to position l is some correct unidentified peg
                b = l - 1;
            else
                a = l;
            end
            % bisection step
            if l == a && b == a + 1
                l = b;
            else
                l = floor( ( a + b ) / 2 );
            end
        end % (bisection loop)
    end % (findNext)
        
    % expand partial solution x and update v
    x( b ) = Sigma( j, b );
    [ s, nlq ] = infoP( Sigma( j, : ), x, y );
    v( j ) = s;
    count = count + nlq;
end % (solution iteration)

% determine last open color:
i = 1;
while sum( ismember( x, i ) ) > 0
    i = i + 1;
end
x( x == 0 ) = i;

fprintf( 'Code found within %i queries:\n', count );
