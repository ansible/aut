#!/usr/bin/env python

import re
import yaml

TRAVIS = {
    'env': [],
    'services': ['docker'],
    'before_script': [
        'docker build -t "aut-$DOCKERFILE" -f '
        '"dockerfiles/$DOCKERFILE" .'
    ],
    'script': [
        'docker run -t '
        '-e PYTHONPATH="/opt/pre/$PRODUCT-$VERSION/lib" '
        '-e PRE="$PRE" '
        '-e PRODUCT="$PRODUCT" '
        '-e VERSION="$VERSION" '
        '-e PPA="$PPA" '
        '"aut-$DOCKERFILE"'
    ],
    'notifications': {
        'webhooks': [
            {
                'if': 'type != cron',
                'urls': ['https://sl.da.gd/travisci?channel=%23relrodtest'],
            },
            {
                'if': 'type == cron',
                'urls': ['https://sl.da.gd/travisci?channel=%23relrodtest'],
                'on_success': 'change',
                'on_failure': 'always',
                'on_error': 'always',
                'on_cancel': 'never',
            },
        ],
    },
}

def main():
    with open('matrix.yml', 'r') as f:
        data = yaml.safe_load(f.read())
    lines = []

    for dockerfile, pres in data['dockerfiles'].items():
        line = 'DOCKERFILE=%s' % dockerfile

        for pre_dict in pres:
            for pre, premeta in pre_dict.items():
                new_line = line
                new_line += ' PRE=%s' % pre

                for product in ('ansible', 'ansible-base'):
                    if premeta:
                        if product in premeta.get('exclude', []):
                            continue

                    for version in data[product]:
                        new_new_line = new_line
                        new_new_line += ' PRODUCT=%s' % product
                        new_new_line += ' VERSION=%s' % version

                        if premeta:
                            version_re = premeta.get('version_re', '')
                            if version_re and not re.search(version_re, version):
                                continue

                            if 'rc' in premeta.get('exclude', []) and 'rc' in version:
                                continue

                            env = premeta.get('env', {})
                            if env:
                                for k, v in env.items():
                                    new_new_line += ' %s=%s' % (k, v)
                        TRAVIS['env'].append(new_new_line)

    print(yaml.dump(TRAVIS))

if __name__ == '__main__':
    main()
