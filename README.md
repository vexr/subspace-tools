# Subspace Tools

### plot-size.sh
#### Shell script to determine ideal plot size. This script assumes you will use the entire drive for the plot. XFS and EXT4 are currently supported.

#### Usage:
```bash
chmod +x plot-size.sh
./plot-size.sh [<disk path>]
```

#### Examples:
```bash
./plot-size.sh
./plot-size.sh /dev/sdb
```
