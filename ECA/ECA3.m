% Elementery Cellular Automata 
% Periodic Boundary
function  A=ECA3(ruleno, initialState, I)
nrows=I+1;
N=length(initialState);
A=zeros(nrows, N);
A(1,:)=initialState;
rule=dec2bin(ruleno,8);
for i=1:8
    ru(i)=str2num(rule(i));
end
for i=2:nrows
    for j=1:N
        m=A(i-1,j);
        if(j==1)
            l=A(i-1,N); r=A(i-1,j+1);
        elseif(j==N)
            l=A(i-1,j-1); r=A(i-1,1);
        else
            l=A(i-1,j-1); r=A(i-1,j+1);
        end
        if(( l & m & r & ru(1)) | ...
                ( l & m &~r & ru(2)) | ...
                ( l &~m & r & ru(3)) | ...
                ( l &~m &~r & ru(4)) | ...
                (~l & m & r & ru(5)) | ...
                (~l & m &~r & ru(6)) | ...
                (~l &~m & r & ru(7)) | ...
                (~l &~m &~r & ru(8)) )
            A(i,j)=1;
        end
    end
end
end