Select Substr(sequence_Name, 1, length(sequence_name)) SeqName from
user_sequences where sequence_name like upper('%&Seq_name%')
/
