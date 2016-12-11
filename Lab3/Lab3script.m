img = rgb2gray(imread('poi.jpg'));
[dx, dy, sums, magnitudes, directions, filteredDirections] = sobel(img);

scaledDirections = (directions + pi) .* (255 / (2 * pi));
scaledFilteredDirections = (filteredDirections + pi) .* (255 / (2 * pi));

imtool(uint8(dx * 8));
imtool(uint8(dy * 8));
imtool(uint8(sums * 8));
imtool(uint8(magnitudes * 8));
imtool(uint8(scaledDirections));
imtool(uint8(scaledFilteredDirections));