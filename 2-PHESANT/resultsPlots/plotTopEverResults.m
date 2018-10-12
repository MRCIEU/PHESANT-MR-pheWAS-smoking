

resDir=strcat(getenv('RES_DIR'),'/results-21753');

x = dataset('file', strcat(resDir,'/results-combined.txt'), 'delimiter', ',');
[~, sx] = sort(x.varName);
x = x(sx,:);


%%%%%
%%%%% keep only results passing 5% FDR threshold

thresh_fdr = 0.05*70/18514;

ix = find(x.pvalueever < thresh_fdr);
x = x(ix,:);



%%%%%
%%%%% description formatting

x.description = strrep(x.description, '\', '');

%%
%% cat multiple - add in value name to description

phesantDir=getenv('PHESANT');
dc_mapping_file=strcat(phesantDir, '/ukb_data_codes/data_codes/fid_dcid_mapping.csv');
dc_map = dataset('file', dc_mapping_file, 'delimiter', ',');

%dc_mapping_file_single=strcat(phesantDir, '/ukb_data_codes/fid_dcid_mapping_catsingle.csv');
%dc_map_single = dataset('file', dc_mapping_file_single, 'delimiter', ',');


dc_dir=strcat(phesantDir, '/ukb_data_codes/data_codes/');

%%
%% for each cat mult result - find data code and add value to description

ix = find(cellfun('length',regexp(x.varName,'#')) == 1);

if 0
for i=1:length(ix)
	idx = ix(i);

	% get field id and field value
	c = strsplit(char(x.varName(idx)), '#');
	fieldID=c(1);
	fieldValue=c(2);

	fprintf('%s %d \n', char(x.varName(idx)), i);

	% get data code id for this field
	dc_map_idx = find(dc_map.fid==str2num(char(fieldID)));
	dcid = dc_map.dc(dc_map_idx);

	fprintf('datacode %d \n', dcid);

	% read in data code values
	dc_values_file = strcat(dc_dir, 'datacode-', num2str(dcid), '.tsv');
	dc_values = dataset('file', dc_values_file);

	% get code value from data code values file
	fprintf('%s \n', class(dc_values.coding));

	if (isa(dc_values.coding, 'cell'))
		code_idx = find(strcmp(dc_values.coding, char(fieldValue))==1);
		fprintf('xxxxxx \n');
	else
		code_idx = find(dc_values.coding == str2num(char(fieldValue)));
	end

	% sometimes we have recoded a field value so it might not exist in the data coding 
	if length(code_idx)>0
		meaning = dc_values.meaning(code_idx);

		% add code value to description
		x.description(idx) = strcat(x.description(idx), '-', meaning);

	end
	fprintf('----------\n');
end
end

%%
%% label formatting

x.varName = strrep(x.varName, '#', ' value ');
x.varLabel = strcat(x.varName, ': ', x.description);
x.varLabel = strrep(x.varLabel, '"','');

%%
%% general plotting settings

colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.8 0.2 0.2]'};
markersx = {'o';'*';'s';};
markersizex = 10;
fontsizex = 8;


%%%%%
%%%%% linear results

rx = 'LINEAR'
%ix = find(strcmp(x.restypenever, rx)==1 & strcmp(x.restypeever, rx)==1 & (x.lowernever > x.upperever | x.lowerever > x.uppernever));
ix = find(strcmp(x.restypenever, rx)==1 & strcmp(x.restypeever, rx)==1);

res = x(ix,:);
res

h=figure('units','inches','position',[.1 .1 10 8]); %4.8]);
plot([0 size(res,1)+1], [0 0], '--', 'color', 'black');
xlim([0 size(res,1)+1]);
set(gca,'XTick',[1:size(res,1)]+0.2);
set(gca,'XTickLabel',res.varLabel);
set(gca,'fontsize',fontsizex);
rotateXLabels(gca, 65);
xlabel('Field');
ylabel('Difference in field (SD)');

for i=1:size(res,1)

	if (strcmp(res.restypenever(i),rx)==1 & strcmp(res.restypeever(i),rx)==1)

	test=2;
        hold on; plot([i+0.2 i+0.2], [res.lowerever(i) res.upperever(i)], '-', 'color', colorx{test}, 'linewidth', 3);
        hold on; p1=plot(i+0.2, res.betaever(i), markersx{test}, 'color', colorx{test}, 'markersize', markersizex, 'MarkerEdgeColor', 'black');

	test=3;
        hold on; plot([i+0.4 i+0.4], [res.lowernever(i) res.uppernever(i)], '-', 'color', colorx{test}, 'linewidth', 3);
        hold on; p2=plot(i+0.4, res.betanever(i), markersx{test}, 'color', colorx{test}, 'markersize', markersizex, 'MarkerEdgeColor', 'black');
	
	end
end

ylim([-0.1 0.1]);

set(h,'Units','Inches');
pos = get(h,'Position');

legend([p1 p2], 'Ever', 'Never', 'location', 'best');
grid on;

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
saveas(h, strcat(resDir, '/figure-interactions-linear.pdf'));



%%%%%
%%%%% binary results

rx = 'LOGISTIC-BINARY'
ix = find(strcmp(x.restypenever, rx)==1 & strcmp(x.restypeever, rx)==1);

res = x(ix,:);

for i=1:size(res,1)
        minx = min(length(res.varLabel{i}), 70);
        res.varLabel{i} = res.varLabel{i}(1:minx);
end

res

h=figure();
plot([0 size(res,1)+1], [0 0], '--', 'color', 'black');
xlim([0 size(res,1)+1]);
set(gca,'XTick',[1:size(res,1)]+0.3);
set(gca,'XTickLabel', res.varLabel);
set(gca,'fontsize',fontsizex);
rotateXLabels(gca, 55);
xlabel('Field');
ylabel('Log odds');

for i=1:size(res,1)


	if (strcmp(res.restypenever(i),rx)==1 & strcmp(res.restypeever(i),rx)==1)

        test=2;
        hold on; plot([i+0.2 i+0.2], [res.lowerever(i) res.upperever(i)], '-', 'color', colorx{test}, 'linewidth', 3);
        hold on; p1=plot(i+0.2, res.betaever(i), markersx{test}, 'color', colorx{test}, 'markersize', markersizex, 'MarkerEdgeColor', 'black');

        test=3;
        hold on; plot([i+0.4 i+0.4], [res.lowernever(i) res.uppernever(i)], '-', 'color', colorx{test}, 'linewidth', 3);
        hold on; p2=plot(i+0.4, res.betanever(i), markersx{test}, 'color', colorx{test}, 'markersize', markersizex, 'MarkerEdgeColor', 'black');
	
	end
end


ylim([-1.5 2]);

legend([p1 p2], 'Ever', 'Never', 'location', 'best');
grid on;

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[30 15], 'paperposition',[0 0 28 13]);
saveas(h, strcat(resDir,'/figure-interactions-binary.pdf'));



%%%%%
%%%%% unordered categorical results

%% we just find the results with low p value and then look at if any are interactions (by looking at CIs of betas)
bonf = 0.05/size(x,1);
thresh = 0.05;
ix = find(strcmp(x.restypenever, rx)==1 & strcmp(x.restypeever, rx)==1);

res = x(ix,:);

res



%%%%%
%%%%% ordered categorical results

rx = 'ORDERED-LOGISTIC';
ix = find(strcmp(x.restypenever, rx)==1 & strcmp(x.restypeever, rx)==1);

res = x(ix,:);
res

h=figure('units','inches','position',[.1 .1 10 8]); %4.8]);
plot([0 size(res,1)+1], [0 0], '--', 'color', 'black');
xlim([0 size(res,1)+1]);
set(gca,'XTick',[1:size(res,1)]+0.3);
set(gca,'XTickLabel', res.varLabel);
set(gca,'fontsize',fontsizex);
rotateXLabels(gca, 65);
xlabel('Field');
ylabel('Log odds');

for i=1:size(res,1)

	if (strcmp(res.restypenever(i),rx)==1 & strcmp(res.restypeever(i),rx)==1)

        test=2;
        hold on; plot([i+0.2 i+0.2], [res.lowerever(i) res.upperever(i)], '-', 'color', colorx{test}, 'linewidth', 3);
        hold on; p1=plot(i+0.2, res.betaever(i), markersx{test}, 'color', colorx{test}, 'markersize', markersizex, 'MarkerEdgeColor', 'black');

        test=3;
        hold on; plot([i+0.4 i+0.4], [res.lowernever(i) res.uppernever(i)], '-', 'color', colorx{test}, 'linewidth', 3);
        hold on; p2=plot(i+0.4, res.betanever(i), markersx{test}, 'color', colorx{test}, 'markersize', markersizex, 'MarkerEdgeColor', 'black');
	
	end
end

set(h,'Units','Inches');
pos = get(h,'Position');

legend([p1 p2], 'Ever', 'Never', 'location', 'best');
grid on;

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
saveas(h, strcat(resDir,'/figure-interactions-ordered.pdf'));







