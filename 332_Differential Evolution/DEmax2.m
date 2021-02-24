%离散差分进化法求函数极值
%初始化
close all;
clc;
NP=20;
D=2;
G=100; 
F=0.5;
%自适应差分进化算法变异概率0.4-0.8.一般选取0.4，离散差分进化算法及传统差分进化算法选择0.5
CR=0.1;
Xs=100;
Xx=-100;
%赋初值
f=randi([Xx,Xs],NP,D);
Fit=zeros(1,NP);
NFit=zeros(1,NP);
v=zeros(NP,D);
u=zeros(NP,D);
trace=zeros(1,G);
%计算第一代种群的适应度
for m=1:NP
    Fit(m)=-((f(m,1)^2+f(m,2)-1)^2+(f(m,1)+f(m,2)^2-7)^2)/200+10;
end
%差分进化算法循环开始
for k=1:G
    %变异操作，选取r1，r2，r3
    for m=1:NP
        a=randperm(NP,3);
        r1=a(1);
        r2=a(2);
        r3=a(3);
        v(m,:)=floor(f(r1,:)+F*(f(r2,:)-f(r3,:)));
    end
    %交叉操作
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
    %边界条件处理,将超出边界的值重新在解空间里随机生成一个值。
    for m=1:NP
        for n=1:D
            if u(m,n)>Xs||u(m,n)<Xx
                u(m,n)=floor(rand*(Xs-Xx)+Xx);
            end
        end
    end
    %计算变异交叉后新种群个体的适应度
    for m=1:NP
        NFit(m)=-((u(m,1)^2+u(m,2)-1)^2+(u(m,1)+u(m,2)^2-7)^2)/200+10;
    end
    %对每一个体逐一进行选择操作
    for m=1:NP
        if NFit(m)>Fit(m)
            f(m,:)=u(m,:);
        end
    end
    %计算选择后新种群的适应度
    for m=1:NP
        Fit(m)=-((f(m,1)^2+f(m,2)-1)^2+(f(m,1)+f(m,2)^2-7)^2)/200+10;
    end
    %记录最大值，并清理内存中无关变量
    trace(k)=max(Fit);
    clear a cr r r1 r2 r3
end
[SortFit,Index]=sort(Fit);
f=f(Index,:);
xbest=f(NP,1);
ybest=f(NP,2);
zbest=SortFit(1,NP);
clear k m n 
figure;
plot(trace);
title('适应度进化曲线');