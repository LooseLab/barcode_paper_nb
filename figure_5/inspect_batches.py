import sys
import argparse
import re

try:
    import pandas as pd
    import numpy as np
    import matplotlib as mpl
    import matplotlib.pyplot as plt
    import seaborn as sns
except ImportError:
    sys.exit(
        """\
Couldn't import third-party libraries. Check the following are installed:
  - pandas
  - numpy
  - seaborn
  - matplotlib

Maybe try:
  pip install seaborn"""
    )


mpl.rcParams.update(
    {
        "figure.dpi": 200,
        "figure.facecolor": "w",
        "axes.grid": True,
        "savefig.facecolor": "w",
    }
)


def reader(fn):
    pat = re.compile(r"(.*?) [\w\.]+ (\d+)R\/(\d+.\d+)s")

    def _reader(fh):
        for line in fh:
            if m := pat.findall(line):
                print(m[0])
                yield m[0]

    with open(fn) as fh:
        df = pd.DataFrame(_reader(fh), columns=["Time", "Reads", "Duration (s)"])
    df["Time"] = pd.to_datetime(df["Time"], format="%Y-%m-%d %H:%M:%S,%f")
    df[["Reads", "Duration (s)"]] = df[["Reads", "Duration (s)"]].astype("float")
    return df


def plot(data, filename, threshold, name=None):
    data = data.sort_values("Time", ascending=True)
    colour = np.where(data["Duration (s)"].gt(threshold), "r", "b")
    fig, ax = plt.subplots(figsize=(18, 6))
    sns.scatterplot(
        data=data,
        x="Time",
        y="Duration (s)",
        c=colour,
        alpha=0.25,
        linewidths=0,
        edgecolor=None,
        s=data["Reads"].pow(1 / 2),
        ax=ax,
    )
    plt.yticks(np.arange(0, np.ceil(data["Duration (s)"].max()) + 1, 1))
    if name is not None:
        fig.suptitle(name)
    fig.tight_layout()
    fig.savefig(filename)
    return fig


def main():
    p = argparse.ArgumentParser()
    p.add_argument("logs", nargs="+", help="readfish log files from `--log-file`")
    p.add_argument(
        "-o",
        "--output",
        required=True,
        help="Output filename. E.G. plot.png (required)",
    )
    p.add_argument(
        "-t", "--title", default=None, help="Title to add to the plot (optional)"
    )
    p.add_argument(
        "-c",
        "--threshold",
        default=1.0,
        type=float,
        help="MinKNOW's `break_reads_after_seconds` value for this sequencing run (optional, default: 1.0)",
    )
    args = p.parse_args()

    df = pd.concat([reader(f) for f in args.logs], ignore_index=True)
    fig = plot(df, args.output, args.threshold, args.title)


if __name__ == "__main__":
    main()
