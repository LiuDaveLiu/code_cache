%% get florescence
val = jsondecode(fileread('F:\HH102\1_HH102S10_C04P02\alf\channel_locations.json'));
% val = jsondecode(fileread('F:\HH102\2_HH102S07_C03P01\alf\channel_locations.json'));
siteposx=zeros(383,1); siteposy=zeros(383,1); siteposz=zeros(383,1);
siteaxial=zeros(383,1); sitelateral=zeros(383,1); sitebrain=zeros(383,1);
for i=0:382
    eval(['siteposx(i+1) = val.channel_' num2str(i) '.x;'])
    eval(['siteposy(i+1) = val.channel_' num2str(i) '.y;'])
    eval(['siteposz(i+1) = val.channel_' num2str(i) '.z;'])
    eval(['siteaxial(i+1) = val.channel_' num2str(i) '.axial;'])
    eval(['sitelateral(i+1) = val.channel_' num2str(i) '.lateral;'])
    eval(['sitelateral(i+1) = val.channel_' num2str(i) '.brain_region_id;'])
end
siteposx=val.origin.bregma(1)-siteposx;
siteposy=val.origin.bregma(2)-siteposy;
siteposz=val.origin.bregma(3)-siteposz;
%% load tiff
origTiff1=imread_big('F:\HH102\reslice of c0.tif channel 1_reslice of c0.tif channel 1_xfm_0.tif'); % dl82
%% plot the eYFP (CCF post IBL)
listOfOrig1=zeros(1,383);
surface=0.14;
% surface=0.23;
xRes=20; yRes=20; zRes=20; % 25 um voxels
for i=1:383
    listOfOrig1(i)=origTiff1(round(siteposz(i)/zRes),round(siteposx(i)/xRes),round(siteposy(i)/yRes));
end
listOfOrig1=[listOfOrig1(1:191) mean(listOfOrig1(191:192)) listOfOrig1(192:end)]; % add reference channel
depths=(384:-1:1)/100-surface;
listOfOrig1=listOfOrig1(depths>0);
depths=depths(depths>0);
figure % plot a line
subplot(161)
plot(listOfOrig1,depths)
box off
ylabel('Depth in the brain (mm)')
set(gca,'TickDir','out')
ax=gca;
ax.YDir = 'reverse';
ylim([0 3.84])
%% fit a peak
x=depths;

[num,p]=numGaussTest(x,listOfOrig1);
[f,gof,o] = fit(x.',listOfOrig1.',['gauss' num2str(num)]);
figure; plot(f,'g',x,listOfOrig1,'g:')
box off
xlabel('Depth in the brain (mm)')
ylabel('Fluorescence')
set(gca,'TickDir','out')
xlim([0 3.84])
axis square
%%
xE=figEDepthBins; diffFR20=psthEvoked - psthBaseline;

[num,p]=numGaussTest(xE,diffFR20);
[fE,gofE,o] = fit(xE.',diffFR20.',['gauss' num2str(num)]);
hold on; plot(fE,xE,diffFR20)
box off
xlabel('Depth in the brain (mm)')
ylabel('spikes/s')
set(gca,'TickDir','out')
xlim([0 3.84])
axis square
%%
figure; plot(f,'g',x,listOfOrig1,'g:')
box off    
ylabel('Fluorescence','Color','g')
set(gca,'TickDir','out')
set(gca,'ycolor','g')
xlim([0 3.84])
yyaxis right
plot(fE,'b',xE,diffFR20,'b:');
set(gca,'ycolor','b')
yyaxis right
ylabel('Spikes/s','Color','b')
xlabel('Depth in the brain (mm)')
axis square
legend off
%% save
save('HH102_S10_C04_2.mat','xE','diffFR20','fE','gofE','x','listOfOrig1','f','gof') % groundtruth
% save('HH102_S07_C03_1.mat','xE','diffFR20','fE','gofE','x','listOfOrig1','f','gof') % groundtruth