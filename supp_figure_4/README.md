First decompress the input, this will save you a million hours

```bash
cd chunked_pafs
parallel 'xz -dT0 {}' ::: *.xz
```
Then run the notebook yayyy