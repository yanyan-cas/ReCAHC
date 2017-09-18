function A = ECA4(ruleNo, initialState, I)
% Elementery Cellular Automata 
% Periodic Boundary
nrows = I + 1;
N = length(initialState);
A = zeros(nrows, N);
A(1,:) = initialState + 1;
rule = dec2bin(ruleNo, 8);
for i = 1:8
    ru(i) = str2num(rule(i));
end
X = initialState + 1;

siz_vec = [2 2 2];
k = [1 cumprod(siz_vec(1:end-1))];
rulearr = (bitget(ruleNo, 1:8) + 1);

SampleNo=2;
for i=2:nrows
    ind = 1;
    Abc=[X(2:end) X(1)]-1;
    ind = ind + (Abc)*k(1);
    ind = ind + (X-1)*k(2);
    Abc2=[X(end) X(1:end-1)]-1;
    ind = ind + (Abc2)*k(3);
    X=rulearr(ind);
    A(SampleNo,:)=X;
    SampleNo=SampleNo+1;
end
A = A -1;
end