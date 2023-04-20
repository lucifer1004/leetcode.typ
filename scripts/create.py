import argparse
import os.path as osp
import pathlib

parser = argparse.ArgumentParser(
    prog='create',
    description='Create new problem')

parser.add_argument('id', type=int)

if __name__ == '__main__':
    args = parser.parse_args()
    if osp.isfile(pathlib.Path('problems', f'p{args.id:04}.typ')):
        print('File already exists, skipped!')
        exit(1)

    with open(pathlib.Path('problems', f'p{args.id:04}.typ'), 'w') as f:
        f.write('#import "../helpers.typ": *\n')
        f.write(f'#import "../solutions/s{args.id:04}.typ": *\n')
        f.write('\n=')

    with open(pathlib.Path('solutions', f's{args.id:04}.typ'), 'w') as f:
        f.write('#import "../helpers.typ": *\n')

    f = open('leetcode.typ', 'r')
    lines = f.readlines()[:-1]
    f.close()

    with open('leetcode.typ', 'w') as f:
        f.write(''.join(lines))
        f.write(f'#include "problems/p{args.id:04}.typ"\n')
