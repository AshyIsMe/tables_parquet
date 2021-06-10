require 'dll'

NB. TODO: build an arrow table from a j table

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
