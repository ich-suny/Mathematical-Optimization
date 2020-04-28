function [x,mu,lambda,output]=multphr(fun,hf,gf,dfun,dhf,dgf,x0)
%����: �ó��ӷ���һ��Լ������: min f(x), s.t. h(x)=0, g(x)>=0
%����: x0�ǳ�ʼ��, fun, dfun�ֱ���Ŀ�꺯�������ݶȣ�
% hf, dhf�ֱ��ǵ�ʽԼ������������������Jacobi�����ת�ã�
% gf, dgf�ֱ��ǲ���ʽԼ������������������Jacobi�����ת�ã�
%���: x�ǽ������ŵ㣬mu, lambda�ֱ�����Ӧ�ڵ�ʽԼ���Ͳ�
% ��ʽԼ���ĳ�������; output�ǽṹ����, ������Ƽ�Сֵf, ��
% ������, �ڵ���������
maxk=900; %����������
sigma=0.001; %������
eta=2.0; theta=0.8; %PHR�㷨�е�ʵ����
k=0; ink=0; %k, ink�ֱ�����������ڵ�������
epsilon=1e-5; %��ֹ���ֵ
x=x0; he=feval(hf,x); gi=feval(gf,x);
n=length(x); l=length(he); m=length(gi);
%ѡȡ���������ĳ�ʼֵ
mu=0.1*ones(l,1); lambda=0.1*ones(m,1);
btak=10; btaold=10; %����������ֹ����������ֵ
while(btak>epsilon & k<maxk)
    %����BFGS�㷨���������Լ��������
    [x,ival,ik]=bfgs('mpsi','dmpsi',x0,fun,hf,gf,dfun,dhf,dgf,mu,lambda,sigma);
    ink=ink+ik;
    he=feval(hf,x); gi=feval(gf,x);
    btak=0.0;
    for(i=1:l), btak=btak+he(i)^2; end
    for(i=1:m)
        temp=min(gi(i),lambda(i)/sigma);
        btak=btak+temp^2;
    end
    btak=sqrt(btak);
    if btak>epsilon
        if(k>=2 & btak > theta*btaold)
            sigma=eta*sigma;
        end
        %���³�������
        for(i=1:l), mu(i)=mu(i)-sigma*he(i); end
        for(i=1:m)
            lambda(i)=max(0.0,lambda(i)-sigma*gi(i));
        end
    end
    k=k+1;
    btaold=btak;
    x0=x;
end
f=feval(fun,x);
output.fval=f;
output.iter=k;
output.inner_iter=ink;
output.bta=btak;
