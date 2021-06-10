NB. libparquet-glib experiments

NB. test.parquet created in python3:
NB. >>> pd.DataFrame({'a':list(range(0,8), 'b':list(range(8,0,-1)}).to_parquet('test.parquet')

require 'dll'

libp=:'"/lib/x86_64-linux-gnu/libparquet-glib.so" '
NB. TODO: the error parameters are **GError in the c declarations, 
NB. I think they should be *x in j, check the dll labs.
gfree=:libp,'g_free n *'
gpafr=:libp,'gparquet_arrow_file_reader_new_path * *c *'
gpafrrt=:libp,'gparquet_arrow_file_reader_read_table * * *'
gatgnc=:libp,'garrow_table_get_n_columns i *'
gatgnr=:libp,'garrow_table_get_n_rows l *'
gatgs=:libp,'garrow_table_get_schema * *'
gatts=:libp,'garrow_table_to_string *c * *'
gasts=:libp,'garrow_schema_to_string *c *'


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

NB. Use g_free() for these glib objects?  domain error currently
NB. Not sure exactly how to free the glib allocated objects just yet, leaking memory currently
NB. gfree&cd"0 s,t,r,<ts,st

memf e

tablestring
)



