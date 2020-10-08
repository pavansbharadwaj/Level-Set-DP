close all
xmin = 0;
xmax = 10;
vfmin = 0;
vfmax = 10;
gammamin = -10;
gammamax = 10;

P = [xmin vfmin gammamin;
    xmin vfmin gammamax;
    xmin vfmax gammamin;
    xmin vfmax gammamax;
    xmax vfmin gammamin;
    xmax vfmin gammamax;
    xmax vfmax gammamax;
    xmax vfmax gammamin];

%plot3(P(:,1),P(:,2),P(:,3),'.')
shp = alphaShape(P(:,1),P(:,2),P(:,3));
plot(shp)

axis equal
shp.inShape([5 5 5])