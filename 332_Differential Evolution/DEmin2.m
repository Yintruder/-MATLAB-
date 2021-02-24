close all
clc;
NP=20;
D=2;
G=100;
F=0.5;
CR=0.1;
Xs=4;
Xx=-4;
f=rand(NP,D)*(Xs-Xx)+Xx;
Fit=zeros(1,NP);
NFit=zeros(1,NP);
v=zeros(NP,D);
u=zeros(NP,D);
trace=zeros(1,G);
for i=1:NP
    Fit(i)=3*cos(f(i,1)*f(i,2))+f(i,1)+f(i,2);
end
for k=1:G
    for m=1:NP;
    a=randperm(NP,3);
    r1=a(1);
    r2=a(2);
    r3=a(3);
    v(m,:)=f(r1,:)+F*(f(r2,:)-f(r3,:));
    end
    r=randi([1,D],1,NP);
    for m=1:NP
        for n=1:D
            cr=rand(1);
            if cr<CR||n==r(m)
                u(m,n)=v(m,n);
            else 
                u(m,n)=f(m,n);
            end
        end
    end
    for m=1:NP
        for n=1:D
            if u(m,n)>Xs||u(m,n)<Xx
                u(m,n)=rand(1)*(Xs-Xx)+Xx;
            end
        end
    end
    for i=1:NP
        NFit(i)=3*cos(u(i,1)*u(i,2))+u(i,1)+u(i,2);
    end
    for i=1:NP
        if NFit(i)<Fit(i)
            f(i,:)=u(i,:);
        end
    end
    for i=1:NP
        Fit(i)=3*cos(f(i,1)*f(i,2))+f(i,1)+f(i,2);
    end
    trace(k)=min(Fit);
end
[SortFit,Index]=sort(Fit);
f=f(Index,:);
xbest=f(1,1);
ybest=f(1,2);
zbest=trace(k);           
figure;
plot(trace);
xlabel('迭代次数');
ylabel('目标函数值');
    
    
    
    
    
    
    
    