from ont_fast5_api import *
import numpy as np
import h5py
from ont_fast5_api import __version__
from ont_fast5_api.compression_settings import COMPRESSION_MAP, VBZ
from ont_fast5_api.conversion_tools.conversion_utils import get_fast5_file_list, batcher, get_progress_bar
from ont_fast5_api.fast5_file import Fast5File, Fast5FileTypeError
from ont_fast5_api.multi_fast5 import MultiFast5File
from ont_fast5_api.fast5_interface import get_fast5_file
import os,glob

import argparse

parser = argparse.ArgumentParser(description='Split Reads into small signal chunks.')
parser.add_argument('signal', metavar='N', type=int, nargs='+',
                    help='signal lengths to extract from read')
parser.add_argument('--input_folder', dest='inputfolder', help="Input folder containing reads to be processed", required=True) 

args = parser.parse_args()

print (args)

for sig in args.signal:
    print (sig)
    if not os.path.exists(f"{sig}_multi"):
        os.mkdir(f"{sig}_multi")
    for file in glob.glob(f"{args.inputfolder}/*.fast5"):
        print(file)
        basename = os.path.basename(file)
        output_file = f"{sig}_multi/{basename}"
        print (output_file)
        fast5_filepath = file
        with MultiFast5File(output_file, 'a') as multi_f5:
            with get_fast5_file(fast5_filepath, mode="r") as f5:
                for read in f5.get_reads():
                    try:
                        #print (dir(read))
                        multi_f5.add_existing_read(read)
                    except:
                        pass
        with MultiFast5File(output_file, 'a') as multi_f5:
            chunk_size = sig
            for read in multi_f5.get_reads(): 
                raw_attrs = read.handle[read.raw_dataset_group_name].attrs
                raw_data = read.handle[read.raw_dataset_name]
                raw_attrs.modify('duration', len(raw_data[:chunk_size]))
                del read.handle["Raw"]["Signal"]
                read.handle["Raw"].create_dataset("Signal",data=raw_data[:chunk_size], dtype='i2', **vars(VBZ))   
