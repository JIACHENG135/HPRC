function x=tbar_fish(q,start,endx,x)
if q==0
    return
else
    x=[x;tbar_fish(q-1,start,(start+endx)/2,[start,(start+endx)/2])];
    x=[x;tbar_fish(q-1,(start+endx)/2,endx,[(start+endx)/2,endx])];
end
end

