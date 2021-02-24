close all;
clc;
NP=50;
D=10;
Xs=20;
Xx=-20;
G=200;
F0=0.4;
CR=0.1;
yz=10^-6;
f=rand(NP,D)*(Xs-Xx)+Xx;
Fit=zeros(1,NP);
NFit=zeros(1,NP);
v=zeros(NP,D);
u=zeros(NP,D);
trace=zeros(1,G);
for m=1:NP
    Fit(m)=sum(f(m,:).^2);
end
for k=1:G
    lamda=exp(1-G/G+1-k);
    F=F0*2^lamda;
    for m=1:NP
        a=randperm(NP,3);
        r1=a(1);
        r2=a(2);
        r3=a(3);
        v(m,:)=f(r1,:)+F*(f(r2,:)-f(r3,:));
        clear a;
    end
    r=randi([1,D],1,NP);
    for m=1:NP
        cr=rand(1,D);
        for n=1:D
            if (cr(n)<CR)||(n==r(m))
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
    for m=1:NP
        NFit(m)=sum(u(m,:).^2);
    end
    for m=1:NP
        if NFit(m)<Fit(m)
            f(m,:)=u(m,:);
        end
    end
    for m=1:NP
        Fit(m)=sum(f(m,:).^2);
    end
    trace(k)=min(Fit);
    if trace(k)<yz
        break;
    end
end
[SortFit,Index]=sort(Fit);
f=f(Index,:);
fbest=f(1,:);
y=min(Fit);
figure;
plot(trace);
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')
