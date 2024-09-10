use tempdb
-- Show Size, Space Used, Unused Space, and Name of all database files
select
        [FileSizeMB] =
                convert(numeric(10,2),round(a.size/128.,2)),
        [UsedSpaceMB] =
                convert(numeric(10,2),round(fileproperty( a.name,'SpaceUsed')/128.,2)) ,
        [UnusedSpaceMB] =
                convert(numeric(10,2),round((a.size-fileproperty( a.name,'SpaceUsed'))/128.,2)) ,
        [DBFileName] = a.name
from
 sysfiles a