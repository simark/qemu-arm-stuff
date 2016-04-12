#!/usr/bin/env python3

import struct
import sys

_FLASH_SZ = 64 * 1024 * 1024

with open(sys.argv[1], 'wb') as f:
	# Fill flash with sequence of 4-byte integers
	for i in range(_FLASH_SZ // 4):
		f.write(struct.pack('<I', i))
