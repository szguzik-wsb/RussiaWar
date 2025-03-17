%(C)Antoni Wilinski 2014
%skypt poczatkowy dla doktorant�w - 
%regresja jako technika kalibracyjna w uczeniu maszynowym 
%regrbtc

%dane - szereg czasowy para walutowa eurusd pr�bkowana co godzine 
%7313 razy do 26 marca 2013;
%Dane maja posta� macierzy C, w kt�rej C(:,[3:6]) to OHLC
%regr1nSL dodanie SL
clear all
clc
close all
warning off
%eurusd1h170125; %dane od 28.07.2022 
%eurusd1d290125;
eurusd1d090318;
%eurusd1h260313;
M=size(C)

kwst=5;  %11-liczba krok�w wstecz dla ustalenia okna aproksymacji
n=1;   %stopien wielomianu aproksymujacego wybrany fragment szeregu czasowego
ml=0;  %licznik udanych predykcji symbolicznej "monety asymetrycznej" - pozycje d�ugie
ms=0;  %licznik udanych poredykcji symbolicznej "monety asymetrycznej" - pozycje kr�tkie
kl=0;  %licznik spe�nienia warunk�w do motwarcia pozycji d�ugiej
ks=0;  %licznik spe�nienia warunk�w do otwarcia pozycji kr�tkiej
SL=0.0010;
Zs(99)=0;

for i=100:11500
    Y=C(i-kwst:i-1,4); %fragment funkcji wyjscia (w �wiecy to warto�� Close)
    [p,S]=polyfit([i-kwst:i-1],Y',n);
    [Ym,delta]=polyval(p, i-kwst:i-1, S); %Ym - model zmiennej zaleznej
    e=Ym-C(i-kwst:i-1,4)'; %wektor b�ed�w pomi�dzy Ym a rzeczywistym przebiegiem Y
    K1(i)=sum(abs(e)); %kryterium dopasowania modelu do rzeczywistego przebiegu
    tr(i)=p(end);
    [Yp,delta]=polyval(p, i-kwst:i, S);
    D1(i)=sign(Yp(end)-Y(end)); %decyzja o otwarciu pozycji d�ugiej lub kr�tkiej
    if D1(i)>0  %rekomendacja by otworzyc pozycje d�ug�
        kl=kl+1;  %licznik spe�nionych warunk�w otwarcia poz. d�ugiej
        Z1(i)=C(i,4)-C(i-1,4)-0.0001;  %zysk lub strata
        if C(i,1)-C(i,3)>SL
            Z1(i)=-SL;
        end
        if Z1(i)>0
            ml=ml+1;  %udana transakcja
        end
    else   %rekomendacja by otworzyc pozycje kr�tk�
        ks=ks+1;
        Z1(i)=-C(i,4)+C(i-1,4)-0.0001;  %zysk lub strata
        if C(i,2)-C(i,1)>SL
            Z1(i)=-SL;
        end
        if Z1(i)>0
            ms=ms+1;
        end
    end
    %Zs(i)=sum(Z1(1:i));
    Zs(i)=Zs(i-1)+Z1(i);
end

m1=size(Zs);
maxZ=-11;
mdd=0;
for i=1:m1(2)
    if Zs(i)>maxZ
        maxZ=Zs(i);
    end
    if (maxZ-Zs(i))>mdd
        mdd=maxZ-Zs(i);
    end
end

Calmar=Zs(end)/mdd


[kl ks]
[ml ms]
[ml/kl ms/ks]  %prawdopodobie�stwo sukcesu - "moneta"
Zs(end)

i


figure(1)  %por�wnanie modelu Ym i rzeczywistego przebiegu aproksymowanej zmiennej Y
plot(C(i-kwst:i-1,4))
hold on
plot(Ym,'r')
title ('Regresja - wielomian 3. stopnia, aproksymacja')

figure(2)  %postawienie punktu prognozy
plot(C(i-kwst:i,4))
hold on
plot(Ym,'r')
hold on
plot(kwst+1,Yp(end),'ro') %k�ko - prognoza
title ('Regresja - wielomian 3. stopnia, predykcja')


figure(3)
plot(Zs, 'LineWidth', 2) %krzywa narastania kapita�u
title('Cumulative Profit  for EURUSD1d')

figure(5)
plot(e)


