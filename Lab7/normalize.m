function c = normalize( vectorImage )

% mi = min(min(vectorImage));
% ma = max(max(vectorImage));
% minr = mi(1,1,1);
% ming = mi(1,1,2);
% minb = mi(1,1,3);
% maxr = ma(1,1,1);
% maxg = ma(1,1,2);
% maxb = ma(1,1,3);
% vectorImage(:,:,1) = (vectorImage(:,:,1) - minr) / (maxr - minr);
% vectorImage(:,:,2) = (vectorImage(:,:,2) - ming) / (maxg - ming);
% vectorImage(:,:,3) = (vectorImage(:,:,3) - minb) / (maxb - minb);
% c = vectorImage .* 255;


mi = min(min(min(vectorImage)));
ma = max(max(max(vectorImage)));
c = ((vectorImage - mi) ./ (ma - mi)) .* 255;


end

