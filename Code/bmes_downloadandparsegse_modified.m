function gsedata=bmes_downloadandparsegse_hollis(gseid, gplid)
% Downloads a GSE series file from NCBI GEO website and saves it on your
% computer. Loads/reads the data into Matlab and returns the data.
% by AhmetSacan.

% * Download e.g.,
% https://ftp.ncbi.nlm.nih.gov/geo/series/GSE5nnn/GSE5847/matrix/GSE5847_series_matrix.txt.gz
% * gunzip()
% * geoseriesread()

%TODO: This function takes time! You should spend some effort to "cache"
%its results.

if ~exist('gseid','var'); gseid='GSE5847'; end
if ~exist('gplid','var')
    gplid='';
else 
    gplid = ['-' gplid];
end

gzfile = [tempdir '/' sprintf('%s.txt.gz',gseid)];

if ~isfile(gzfile)

%Ignore the following line, it only works on Ahmet's computer.
if 0&&any(exist('bmes_downloadandparsegse_ahmet')==[2 5 6]); gsedata=eval('bmes_downloadandparsegse_ahmet(gseid)'); return; end


url = sprintf('https://ftp.ncbi.nlm.nih.gov/geo/series/GSE%dnnn/%s/matrix/%s%s_series_matrix.txt.gz', ...
	floor(str2double(gseid(4:end))/1000),gseid,gseid, gplid);

fprintf('Downloading %s ...\n',url);

urlwrite(url, gzfile);
end

files = gunzip( gzfile );
file = files{1};

fprintf('Reading %s ...\n',file);
gsedata = geoseriesread( file );
