function [outline, shape] = circle(x, y, r)
%CIRCLE is designed to easily plot the equation of a circle using the
%center (x,y) and the radius (r) over a constant continuous interval of
%angles.

%define angles
theta=0:0.05:2*pi+0.05;

%define grey color
grey = [179, 182, 188] ./ 256;

%plot the circle outline and return plot handle
outline = line(x+r*sin(theta),y+r*cos(theta), 'Color', grey);
shape = patch(x+r*sin(theta), y+r*cos(theta), 1, 'FaceColor', grey);

end