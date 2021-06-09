
require 'dll'


0 : 0
NB. libarrow-glib experiments
liba=:'"/lib/x86_64-linux-gnu/libarrow-glib.so" '
i32abn=:'garrow_int32_array_builder_new *'
NB. i32abav=:'garrow_int32_array_builder_append_value c * i *'
i32abav=:'garrow_int32_array_builder_append_value i * i *'

NB. AA TODO: 'garrow_array_builder_finish ...'

e=.mema 4 NB. pointer to int32 for error codes
b=.(liba,i32abn) cd '' NB. New array builder
s=.(liba,i32abav) cd b ; 42 ; e
memf e
)



NB. libparquet-glib experiments

NB. test.parquet created in python3:
NB. >>> pd.DataFrame({'a':list(range(0,8), 'b':list(range(8,0,-1)}).to_parquet('test.parquet')

libp=:'"/lib/x86_64-linux-gnu/libparquet-glib.so" '
gpafr=:libp,'gparquet_arrow_file_reader_new_path * *c *'
gpafrrt=:libp,'gparquet_arrow_file_reader_read_table * * *'
gatgnc=:libp,'garrow_table_get_n_columns i *'
gatgnr=:libp,'garrow_table_get_n_rows l *'
gatgs=:libp,'garrow_table_get_schema * *'
gatts=:libp,'garrow_table_to_string *c * *'
gasts=:libp,'garrow_schema_to_string *c *'


NB. TODO: the error parameters are **GError in the c declarations, 
NB. I think they should be *x in j, check the dll labs.

e=.mema 4 NB. pointer to int32 for error codes
r=.gpafr cd 'test.parquet' ; <<e NB. New *GParquetArrowFileReader
NB. 0{r is a pointer to the reader
NB. TODO do we need to free the reader manually?

t=.gpafrrt cd (0{r) ; <<e
NB. 0{t is a pointer to the table

gatgnr cd <(0{t) NB. number of rows = 8
gatgnc cd <(0{t) NB. number of columns = 2

s=.gatgs cd <(0{t)
st=.>{.gasts cd <(0{s) NB. pointer to schema text
memr st,0,_1
NB. a: int64
NB. b: int64
ts=.>gatts cd ({.t) ; <<e
memr ts,0,_1

memf e




