function [num,p]=numGaussTest(x,y)
for i=1:7
    [~,gof] = fit(x.',y.',['gauss' num2str(i)]);
    [~,gof2] = fit(x.',y.',['gauss' num2str(i+1)]);
    err1=gof.sse;
    err2=gof2.sse;
    p=ftest(length(x),i*3,(i+1)*3,err1,err2);
    if p>0.001
        num=i;
        break
    else
        num=i+1;
    end
end