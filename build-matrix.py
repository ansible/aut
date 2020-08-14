#!/usr/bin/env python

import yaml

def main():
    with open('matrix.yml', 'r') as f:
        data = yaml.safe_load(f.read())
    lines = []

    for dockerfile, pres in data['dockerfiles'].items():
        line = {'DOCKERFILE': dockerfile}

        for pre, premeta in pres.items():
            new_line = line.copy()
            new_line['PRE'] = pre

            for product in ('ansible', 'ansible-base'):
                if premeta and product in premeta.get('exclude', []):
                    continue

                for version in data[product]:
                    new_new_line = new_line.copy()
                    new_new_line['PRODUCT'] = product
                    new_new_line['VERSION'] = version
                    lines.append(new_new_line)

    for line in lines:
        out = '- '
        for k, v in line.items():
            out += '{0}={1:<15}'.format(k, v)
        out = out.strip()
        print('  ' + out)

if __name__ == '__main__':
    main()
