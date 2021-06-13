NB. libparquet-glib experiments

NB. test.parquet created in python3:
NB. >>> pd.DataFrame({'a':list(range(0,8), 'b':list(range(8,0,-1)}).to_parquet('test.parquet')

require 'dll'

liba=:'"/lib/x86_64-linux-gnu/libarrow-glib.so" '
libp=:'"/lib/x86_64-linux-gnu/libparquet-glib.so" '
NB. TODO: the error parameters are **GError in the c declarations, 
NB. I think they should be *x in j, check the dll labs.

gfree=:liba,'g_free n *'
NB. GParquetArrowFileReader
gpafr=:libp,'gparquet_arrow_file_reader_new_path * *c *'
gpafrrt=:libp,'gparquet_arrow_file_reader_read_table * * *'

NB. GArrowTable
gatgnc=:libp,'garrow_table_get_n_columns i *'
gatgnr=:libp,'garrow_table_get_n_rows l *'
gatgcd=:libp,'garrow_table_get_column_data * * i'
gatgs=:libp,'garrow_table_get_schema * *'
gatts=:libp,'garrow_table_to_string *c * *'

NB. GArrowSchema
gasts=:libp,'garrow_schema_to_string *c *'

NB. GArrowChunkedArray
gacagvdt=:libp,'garrow_chunked_array_get_value_data_type * *'
gacagnr=:libp,'garrow_chunked_array_get_n_rows l *'
gacagnc=:libp,'garrow_chunked_array_get_n_chunks i *'
gacagc=:libp,'garrow_chunked_array_get_chunk * * i'
NB. 'garrow_chunked_array_get_chunks * *' NB. Possibly use this instead?

NB. GArrowDataType
gadtts=:libp,'garrow_data_type_to_string *c *'
gadtgi=:libp,'garrow_data_type_get_id i *' NB. GArrowType enum


NB. GArrowArray
gaagvdt=:libp,'garrow_array_get_value_data_type * *'
NB. GArrowInt64Array
gai64agvs=:libp,'garrow_int64_array_get_values * * *'
gai64agv=:libp,'garrow_int64_array_get_value l * l'



readparquetToString=: 3 : 0
e=.mema 4 NB. pointer to int32 for error codes
r=.{.gpafr cd y ; <<e NB. New GParquetArrowFileReader*
t=.{.gpafrrt cd r ; <<e NB. GArrowTable*
nrows=.{.gatgnr cd <t NB. number of rows = 8
ncols=.{.gatgnc cd <t NB. number of columns = 2
s=.{.gatgs cd <t NB. GArrowSchema*
st=.>{.gasts cd <s NB. schema text gchar*
memr st,0,_1
NB. a: int64
NB. b: int64
ts=.>{.gatts cd t ; <<e
memf e
tablestring=.memr ts,0,_1
)

readparquet=: 3 : 0
e=.mema 4 NB. pointer to int32 for error codes
r=.{.gpafr cd y ; <<e NB. New GParquetArrowFileReader*
t=.{.gpafrrt cd r ; <<e NB. GArrowTable*
nrows=.{.gatgnr cd <t NB. number of rows = 8
ncols=.{.gatgnc cd <t NB. number of columns = 2
s=.{.gatgs cd <t NB. GArrowSchema*
st=.>{.gasts cd <s NB. schema text gchar*
memr st,0,_1
NB. a: int64
NB. b: int64
ts=.>{.gatts cd t ; <<e
tablestring=.memr ts,0,_1

ca =. {.gatgcd cd t ; 0 NB. GArrowChunkedArray
NB. TODO Get the datatype, the chunks of GArrowArrays and convert to j array
nchunks =. {.gacagnc cd <ca
a =. {.gacagc cd ca ; 0 NB. Chunk 0

dt =. {.gacagvdt cd <ca NB. GArrowDataType
NB. TODO GArrowDataType -> to GArrowType enum


table =. 0$0 NB. TODO - fill with data

NB. Use g_free() for these glib objects?  domain error currently
NB. Not sure exactly how to free the glib allocated objects just yet, leaking memory currently
NB. gfree&cd"0 s,t,r,<ts,st

memf e

table
)

readGArrowInt64Array=. 3 : 0
l=.mema 8
v=.>{.gai64agvs cd y ; <<l
len=.memr l,0,1,4
memf l
memr v,0,len,4
)



