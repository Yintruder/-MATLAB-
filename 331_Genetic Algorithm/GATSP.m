close all;
clc;
c=[1304 2321;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;...
    4196 1044;4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;...
    1332 695;3715 1678;3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;...
    4263 2931;3429 1908;3507 2376;3394 2643;3439 3201;2935 3240;3140 3550;...
    2545 2357;2778 2826;2370 2975];
N=size(c,1);
D=zeros(N);
for i=1:N
    for j=1:N
        D(i,j)=((c(i,1)-c(j,1))^2+(c(i,2)-c(j,2))^2)^0.5;
    end
end
NP=200;
G=1000;
f=zeros(NP,N);
F=[];
for i=1:NP
    f(i,:)=randperm(N);
end
R=f(1,:);
len=zeros(NP,1);
Rlength=zeros(1,G);
for gen=1:G;
    for i=1:NP
      len(i,1)=D(f(i,N),f(i,1));
        for j=1:(N-1)
            len(i,1)=len(i,1)+D(f(i,j),f(i,j+1));
        end
    end
    maxlen=max(len);
    minlen=min(len);
    rr=find(len==minlen);
    R=f(rr(1,1),:);
    fitness=zeros(length(len),1);
    for i=1:length(len)
        fitness(i,1)=(1-((len(i,1)-minlen)/(maxlen-minlen+0.001)));
    end
    nn=0;
    for i=1:NP
        if fitness(i,1)>=rand
            nn=nn+1;
            F(nn,:)=f(i,:);
        end
    end
    [aa,bb]=size(F);
    while aa<NP
        nnper=randperm(nn);
        A=F(nnper(1),:);
        B=F(nnper(2),:);
        W=ceil(N/10);
        p=unidrnd(N-W+1);
        for i=1:W
            x=find(A==B(p+i-1));
            y=find(B==A(p+i-1)); 
            temp=A(p+i-1);
            A(p+i-1)=B(p+i-1);
            B(p+i-1)=temp;
            temp=A(x);
            A(x)=B(y);
            B(y)=temp;
        end
        p1=floor(1+N*rand());
        p2=floor(1+N*rand());
        if p1==p2
            p1=floor(1+N*rand());
            p2=floor(1+N*rand());
        end
        temp=A(p1);
        A(p1)=A(p2);
        A(p2)=temp;
        temp=B(p1);
        B(p1)=B(p2);
        B(p2)=temp;
        F=[F;A;B];
        [aa,bb]=size(F);
    end
    if aa>NP
        F=F(1:NP,:);
    end
    f=F;
    f(1,:)=R;
    clear F;
    Rlength(gen)=minlen;  
end
figure;
for i=1:N-1
    plot([c(R(i),1),c(R(i+1),1)],[c(R(i),2),c(R(i+1),2)],'bo-')
    hold on;
end
plot([c(R(N),1),c(R(1),1)],[c(R(N),2),c(R(1),2)],'ro-');
title(['优化最短路径：',num2str(minlen)]);
figure
plot(Rlength);
xlabel('迭代次数');
ylabel('目标函数值');
title('适应度进化曲线');