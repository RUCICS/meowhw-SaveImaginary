cat test.txt > /dev/null
# 获取文件系统块大小
BLKSIZE=$(stat --format="%B" test.txt 2>/dev/null || echo 4096)
echo "File system block size: $BLKSIZE"

# buf_size
PAGE_SIZE=$(getconf PAGESIZE 2>/dev/null || echo 4096)
BUF_SIZE=$(( PAGE_SIZE > BLKSIZE ? PAGE_SIZE : BLKSIZE ))
echo "Base buffer size: $BUF_SIZE"


MULTIPLIERS=(1 2 4 8 16 20 24 32 64 128 256)


OUTPUT="buffer_rates.csv"
echo "Multiplier,BufferSize,Rate_MBps" > $OUTPUT

for A in "${MULTIPLIERS[@]}"; do
  
    BS=$((A * BUF_SIZE))
    echo "Testing buffer size: $BS bytes (A=$A)"
    
    # 使用 dd 测试，3 次取平均
    RATE=0
    SUCCESS=0
    for i in {1..3}; do
  
        DD_OUTPUT=$(dd if=test.txt of=/dev/null bs=$BS 2>&1)
       
        RESULT=$(echo "$DD_OUTPUT" | grep -o "[0-9.]\+ [MG]B/s" | head -1)
        if [ -n "$RESULT" ]; then
            VALUE=$(echo "$RESULT" | cut -d' ' -f1)
            UNIT=$(echo "$RESULT" | cut -d' ' -f2)
            if [ "$UNIT" = "GB/s" ]; then
                VALUE=$(echo "scale=2; $VALUE * 1000" | bc)
            fi
            RATE=$(echo "$RATE + $VALUE" | bc)
            SUCCESS=$((SUCCESS + 1))
        else
            echo "Warning: Failed to parse rate for A=$A, run $i"
            echo "$DD_OUTPUT"
        fi
    done
    if [ $SUCCESS -gt 0 ]; then
        RATE=$(echo "scale=2; $RATE / $SUCCESS" | bc)
        echo "$A,$BS,$RATE" >> $OUTPUT
    else
        echo "$A,$BS,0" >> $OUTPUT
    fi
done
cat $OUTPUT