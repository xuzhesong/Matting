%%
rgb_path = '../dataset/input_training_lowres/GT05.png';
trimap_path = '../dataset/trimap_training_lowres/Trimap1/GT05.png';
% rgb = imread(rgb_path);
% unknownImg = imread(rgb_path);
% trimap = imread(trimap_path);
% width = size(trimap,1);
% height = size(trimap,2);
Iteration = 50;
oriVar =8;

rgb = imread(rgb_path);
unknownImg = double(rgb);
trimap = imread(trimap_path);
[Fmean, Bmean, coF, coB, F_mask, B_mask, U_mask] = match_img(rgb, trimap);
% [fmean, fcovariance] = cal_mean_cov(F_rgb);
% [bmean, bcovariance] = cal_mean_cov(B_rgb);
% [umean, ucovariance] = cal_mean_cov(U_rgb);
% 
% disp([fmean,bmean,umean])
% disp(fcovariance)
% disp(bcovariance)
height = size(rgb,2);
width = size(rgb,1);
%%
unknownAlpha = double(trimap) / 255.0;
unknownF = unknownImg;
unknownB = unknownImg;
invcoF = inv(coF);
invcoB = inv(coB);
for b=1:height
 for a=1:width
     if trimap(a,b)> 255*0.05 && trimap(a,b)< 255 * 0.95
         if any(unknownImg(a,b,:)),
                alpha = 0;
                count = 0;
                if(a>1&&b>1)
                   alpha = alpha + unknownAlpha(a-1,b-1);
                   count = count +1;
                end
                if(b>1)
                    alpha = alpha + unknownAlpha(a,b-1);
                   count = count +1;
                end
                if(a<width&&b>1)
                   alpha = alpha + unknownAlpha(a+1,b-1);
                   count = count +1;
                end
                if(a>1)
                    alpha = alpha + unknownAlpha(a-1,b);
                   count = count +1; 
                end
                if(a<width)
                   alpha = alpha + unknownAlpha(a+1,b);
                   count = count +1; 
                end
                if(a>1&&b<height)
                   alpha = alpha + unknownAlpha(a-1,b+1);
                   count = count +1; 
                end
                if(b<height)
                   alpha = alpha + unknownAlpha(a,b+1);
                   count = count +1; 
                end
                if(a<width&&b<height)
                   alpha = alpha + unknownAlpha(a+1,b+1);
                   count = count +1;
                end
                alpha = alpha / count;
                preAlpha = alpha;
                for i=1:Iteration,
    
                    UL = invcoF + eye(3)*(alpha*alpha)/(oriVar*oriVar);
                    UR =eye(3)*alpha*(1-alpha)/(oriVar*oriVar);
                    DL = eye(3)*alpha*(1-alpha)/(oriVar*oriVar);
                    DR = invcoB + eye(3)*(1-alpha)*(1-alpha)/(oriVar*oriVar);
                    A = [UL UR;DL DR];
                    C = reshape(unknownImg(a,b,:),3,1);
                    BU = invcoF*Fmean' + C*alpha/(oriVar*oriVar);
                    BD = invcoB*Bmean' + C*(1-alpha)/(oriVar*oriVar);
                    B = [BU; BD];
                    x = A\B;
                    tempF = x(1:3); tempB = x(4:6);
                    alpha = dot((C - tempB), (tempF - tempB)) / norm(tempF-tempB).^2;
                    if abs(preAlpha - alpha)< 0.0001,
                        break;
                    end
                    preAlpha = alpha;
                    
                end
                unknownF(a,b,:) = tempF;
                unknownB(a,b,:) = tempB;
                unknownAlpha(a,b) = alpha;
                
         end
     end
 end 
end
disp(i)
%%
% unknownAlpha(F_mask == 1) = 0;
% unknownAlpha(B_mask == 1) = 1;
% unknownAlpha(unknownAlpha >= 0.95) = 1;
imshow(unknownAlpha)