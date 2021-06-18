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


NB. GArrow Arrays are all immutable and internally refcounted, can we ignore cleanup?
NB. Use g_free() for these glib objects?  domain error currently
NB. Not sure exactly how to free the glib allocated objects just yet, leaking memory currently
NB. gfree&cd"0 s,t,r,<ts,st

readparquet=: 3 : 0
e=.mema 4 NB. pointer to int32 for error codes
r=.{.gpafr cd y ; <<e NB. New GParquetArrowFileReader*
t=.{.gpafrrt cd r ; <<e NB. GArrowTable*
memf e NB. TODO Check for errors
nrows=.>{.gatgnr cd <t NB. number of rows = 8
ncols=.>{.gatgnc cd <t NB. number of columns = 2
table =. (i. ncols) readTableCol t
NB. TODO: join column names to table
table
)


NB. TODO: check datatype of each col and call correct readTYPE verb
NB. dt =. {.gacagvdt cd <ca NB. GArrowDataType. TODO GArrowDataType -> to GArrowType enum
NB. dts=.>{.gadtts cd <dt
NB. dts=.memr dts,0,_1
readTableCol=: 4 : 0
NB. x=indexes, y=GArrowTable*
ca=.{."1 gatgcd cd y (;"1 0) x NB. GArrowChunkedArray

NB. dts =. {."1 gacagvdt cd"1 0 <"0 ca
NB. typeids =. ... gadtgi ...

chunksi=. i."0 >{."1 gacagnc cd"1 0 <"0 ca
chunks=.{."1 gacagc cd (<"0 ca) ,. <"0 chunksi
readGArrowInt64Array"0 chunks
)

readGArrowInt64Array=: 3 : 0
l=.mema 8
v=.>{.gai64agvs cd y ; <<l
len=.memr l,0,1,4
memf l
memr v,0,len,4
)




NB. GArrowType enum from arrow-glib/type.h
ga_NA =. 3 : '''GARROW_TYPE_NA_Array NOT IMPLEMENTED'''
ga_BOOLEAN =. 3 : '''GARROW_TYPE_BOOLEAN_Array NOT IMPLEMENTED'''
ga_UINT8 =. 3 : '''GARROW_TYPE_UINT8_Array NOT IMPLEMENTED'''
ga_INT8 =. 3 : '''GARROW_TYPE_INT8_Array NOT IMPLEMENTED'''
ga_UINT16 =. 3 : '''GARROW_TYPE_UINT16_Array NOT IMPLEMENTED'''
ga_INT16 =. 3 : '''GARROW_TYPE_INT16_Array NOT IMPLEMENTED'''
ga_UINT32 =. 3 : '''GARROW_TYPE_UINT32_Array NOT IMPLEMENTED'''
ga_INT32 =. 3 : '''GARROW_TYPE_INT32_Array NOT IMPLEMENTED'''
ga_UINT64 =. 3 : '''GARROW_TYPE_UINT64_Array NOT IMPLEMENTED'''
ga_INT64 =. readGArrowInt64Array
ga_HALF_FLOAT =. 3 : '''GARROW_TYPE_HALF_FLOAT_Array NOT IMPLEMENTED'''
ga_FLOAT =. 3 : '''GARROW_TYPE_FLOAT_Array NOT IMPLEMENTED'''
ga_DOUBLE =. 3 : '''GARROW_TYPE_DOUBLE_Array NOT IMPLEMENTED'''
ga_STRING =. 3 : '''GARROW_TYPE_STRING_Array NOT IMPLEMENTED'''
ga_BINARY =. 3 : '''GARROW_TYPE_BINARY_Array NOT IMPLEMENTED'''
ga_FIXED_SIZE_BINARY =. 3 : '''GARROW_TYPE_FIXED_SIZE_BINARY_Array NOT IMPLEMENTED'''
ga_DATE32 =. 3 : '''GARROW_TYPE_DATE32_Array NOT IMPLEMENTED'''
ga_DATE64 =. 3 : '''GARROW_TYPE_DATE64_Array NOT IMPLEMENTED'''
ga_TIMESTAMP =. 3 : '''GARROW_TYPE_TIMESTAMP_Array NOT IMPLEMENTED'''
ga_TIME32 =. 3 : '''GARROW_TYPE_TIME32_Array NOT IMPLEMENTED'''
ga_TIME64 =. 3 : '''GARROW_TYPE_TIME64_Array NOT IMPLEMENTED'''
ga_INTERVAL_MONTHS =. 3 : '''GARROW_TYPE_INTERVAL_MONTHS_Array NOT IMPLEMENTED'''
ga_INTERVAL_DAY_TIME =. 3 : '''GARROW_TYPE_INTERVAL_DAY_TIME_Array NOT IMPLEMENTED'''
ga_DECIMAL128 =. 3 : '''GARROW_TYPE_DECIMAL128_Array NOT IMPLEMENTED'''
ga_DECIMAL256 =. 3 : '''GARROW_TYPE_DECIMAL256_Array NOT IMPLEMENTED'''
ga_LIST =. 3 : '''GARROW_TYPE_LIST_Array NOT IMPLEMENTED'''
ga_STRUCT =. 3 : '''GARROW_TYPE_STRUCT_Array NOT IMPLEMENTED'''
ga_SPARSE_UNION =. 3 : '''GARROW_TYPE_SPARSE_UNION_Array NOT IMPLEMENTED'''
ga_DENSE_UNION =. 3 : '''GARROW_TYPE_DENSE_UNION_Array NOT IMPLEMENTED'''
ga_DICTIONARY =. 3 : '''GARROW_TYPE_DICTIONARY_Array NOT IMPLEMENTED'''
ga_MAP =. 3 : '''GARROW_TYPE_MAP_Array NOT IMPLEMENTED'''
ga_EXTENSION =. 3 : '''GARROW_TYPE_EXTENSION_Array NOT IMPLEMENTED'''
ga_FIXED_SIZE_LIST =. 3 : '''GARROW_TYPE_FIXED_SIZE_LIST_Array NOT IMPLEMENTED'''
ga_DURATION =. 3 : '''GARROW_TYPE_DURATION_Array NOT IMPLEMENTED'''
ga_LARGE_STRING =. 3 : '''GARROW_TYPE_LARGE_STRING_Array NOT IMPLEMENTED'''
ga_LARGE_BINARY =. 3 : '''GARROW_TYPE_LARGE_BINARY_Array NOT IMPLEMENTED'''
ga_LARGE_LIST =. 3 : '''GARROW_TYPE_LARGE_LIST_Array NOT IMPLEMENTED'''

NB. Gerund. TODO: Use this gerund in readTableCol, index the gerund by GArrowType enum number
readers=.ga_NA`ga_BOOLEAN`ga_UINT8`ga_INT8`ga_UINT16`ga_INT16`ga_UINT32`ga_INT32`ga_UINT64`ga_INT64`ga_HALF_FLOAT`ga_FLOAT`ga_DOUBLE`ga_STRING`ga_BINARY`ga_FIXED_SIZE_BINARY`ga_DATE32`ga_DATE64`ga_TIMESTAMP`ga_TIME32`ga_TIME64`ga_INTERVAL_MONTHS`ga_INTERVAL_DAY_TIME`ga_DECIMAL128`ga_DECIMAL256`ga_LIST`ga_STRUCT`ga_SPARSE_UNION`ga_DENSE_UNION`ga_DICTIONARY`ga_MAP`ga_EXTENSION`ga_FIXED_SIZE_LIST`ga_DURATION`ga_LARGE_STRING`ga_LARGE_BINARY`ga_LARGE_LIST
