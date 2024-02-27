

%%
r = runtests("./TestReadImage");
disp(r);
%%
r = runtests("./TestMatchImage");
disp(r);
%%
r = runtests("./TestAlpha");
disp(r);
%%
Ir = double(imread("GT01.png")/255);
a = Ir(:,:,1);
Ip = double(imread("pre.png")/255);
I = abs(Ir-Ip);
sad = SAD(Ip,Ir);
figure(1);
imshow(Ir);
figure(2);
imshow(I);
