from pathlib import Path
import pod5

import argparse
from rich import print

parser = argparse.ArgumentParser(description="Split Reads into small signal chunks.")
parser.add_argument(
    "signal_lens",
    metavar="N",
    type=int,
    nargs="+",
    help="signal lengths to extract from read",
)
parser.add_argument(
    "--input-folder",
    dest="input_folder",
    help="Input folder containing reads to be processed. Is not recursive, will not descend into sub directories.",
    required=True,
)
parser.add_argument(
    "--output-folder",
    dest="output_folder",
    help="Output folder destination. Default is current working directory",
    default="."
)

args = parser.parse_args()

signal_lengths = args.signal_lens + ["original"]
for chunk_size in signal_lengths:
    print(f"Chunking signal to {chunk_size}")
    output_path = Path(f"{args.output_folder}/{chunk_size}_multi")
    if not output_path.exists():
        output_path.mkdir(exist_ok=False, parents=True)
    for pod5_file in Path(f"{args.input_folder}").glob("*.pod5"):
        print(f"Pulling signal from {pod5_file}")
        file_basename = pod5_file.name
        output_file = Path(f"{output_path}/{file_basename}")
        print(f"Writing to {output_file}")
        fast5_filepath = pod5_file
        with pod5.DatasetReader(pod5_file, "a") as pod5_reader, pod5.Writer(
            output_file
        ) as pod5_writer:
            for read in pod5_reader.reads():
                subset_signal = read.signal[:chunk_size] if chunk_size != "original" else read.signal
                subset_read = pod5.Read(
                    read_id=read.read_id,
                    end_reason=read.end_reason,
                    calibration=read.calibration,
                    pore=read.pore,
                    run_info=read.run_info,
                    num_minknow_events=read.num_minknow_events,
                    read_number=read.read_number,
                    tracked_scaling=read.tracked_scaling,
                    median_before=read.median_before,
                    predicted_scaling=read.predicted_scaling,
                    start_sample=read.start_sample,
                    signal=subset_signal,
                )
                pod5_writer.add_read(subset_read)
