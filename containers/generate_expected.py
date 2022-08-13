#!/usr/bin/env python3

import sys
import itertools as it
import operator

def magic(c_ids, w_ids):
    containers = {key:[v[0] for v in value] for key, value in it.groupby(sorted(c_ids, key=operator.itemgetter(1)), operator.itemgetter(1))}
    warehouses = dict(w_ids)
    files = {warehouses[_id]:containers[_id] for _id in containers}
    for id_ in warehouses:
        try:
            files[warehouses[id_]]
        except KeyError:
            files[warehouses[id_]] = []
    return files


def main(argv):
    testname = argv[0]
    with open("container/{}".format(testname)) as f_container, open("warehouse/{}".format(testname)) as f_warehouse:
        # skip first line
        f_warehouse.__next__()

        container = [line.split() for line in f_container]
        warehouse = [line.split() for line in f_warehouse]

    files = magic(container, warehouse)
    for file in files:
        with open("expected/{}/{}".format(testname, file), "w+") as f:
            for line in files[file]:
                print(line, file=f)
            


if __name__ == "__main__":
    main(sys.argv[1:])
