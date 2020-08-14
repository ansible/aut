#!/usr/bin/env python

import re
import yaml

def main():
    with open('matrix.yml', 'r') as f:
        data = yaml.safe_load(f.read())
    lines = []

    for dockerfile, pres in data['dockerfiles'].items():
        line = {'DOCKERFILE': dockerfile}

        for pre_dict in pres:
            for pre, premeta in pre_dict.items():
                new_line = line.copy()
                new_line['PRE'] = pre

                for product in ('ansible', 'ansible-base'):
                    if premeta:
                        if product in premeta.get('exclude', []):
                            continue

                    for version in data[product]:
                        new_new_line = new_line.copy()
                        new_new_line['PRODUCT'] = product
                        new_new_line['VERSION'] = version

                        if premeta:
                            version_re = premeta.get('version_re', '')
                            if version_re and not re.search(version_re, version):
                                continue

                            env = premeta.get('env', {})
                            if env:
                                for k, v in env.items():
                                    new_new_line[k] = v
                        lines.append(new_new_line)

    # Pretty formatting fuckery. There's probably a better way than iterating
    # 3 times, but for the amount of data we're working with, who gives a crap?

    # Get k=v components for each line
    outlines = []
    for line in lines:
        components = []
        for k, v in line.items():
            components.append('{0}={1}'.format(k, v))
        outlines.append(components)

    # outlines is a list of lists. outer element is line, inner are components
    # Get the max component length for each column and store it by column idx
    comp_lens = {}
    for line in outlines:
        for idx, comp in enumerate(line):
            if idx not in comp_lens:
                comp_lens[idx] = 0
            if len(comp) > comp_lens[idx]:
                comp_lens[idx] = len(comp)

    # comp_lens is a component-index-keyed dict of max component lengths
    # ljust using it and print the lines
    for line in outlines:
        out = '  - '
        for idx, comp in enumerate(line):
            out += comp.ljust(comp_lens[idx] + 2)
        print(out.rstrip())


if __name__ == '__main__':
    main()
