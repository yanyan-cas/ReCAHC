function dataset = ECA_Input(ruleNo, I, input, g)
%Apply ECA to the input matrix, and return the last g lines
%I the nomber of ECA iterations
%g The number of rows that selected to the ouput g <= 1 + I
%input The input Matrix

M = size(input, 1);
for i=1:M
    initialstate=input(i,:);
    A=ECA4(ruleno, initialstate, I); %the ECA rule is in another function
    dataset1((g*(i-1))+1:g*i,:)=A(I-g+2:end,:);
    dataset2=(dataset1((g*(i-1))+1:g*i,:))';
    dataset(i,:)=(dataset2(:))';
end
end