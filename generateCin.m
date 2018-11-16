function cin=generateCin(j,phi)
beta=pi/phi;
cin=[];
if rem(floor(j/beta),2)==0
    for i=1:beta-1
        cin=[cin;[j+i,j+i+beta];[j+i j+i+beta-1]];
    end
    cin=[cin;[j j+beta];[j j+2*beta-1]];
else
    for i=0:beta-2
        cin=[cin;[j+i j+i+beta];[j+i j+i+beta+1]];
    end
    cin=[cin;[j+beta-1 j+beta];[j+beta-1 j+2*beta-1]];
end
%     cin(cin==max(cin))=1;
end