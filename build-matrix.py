#!/usr/bin/env python

import re
import yaml

YAML = {
    'name': 'Ansible User Artifact Tests',
    'on': {
        'push': None,
        'pull_request': None,
        'schedule': [
            { 'cron': '0 0 * * *', }
        ],
    },
    'jobs': {
        'build': {
            'runs-on': 'ubuntu-latest',
            'timeout-minutes': 20,  # TODO: config?
            'strategy': {
                # We want to see all failures.
                'fail-fast': False,
                'matrix': {
                    'include': [],
                },
            },
            'steps': [
                {
                    'name': 'Clone repo',
                    'uses': 'actions/checkout@v2',
                 },
                {
                    'name': 'Build container image',
                    'run': 'docker build -t "aut-${{ matrix.dockerfile }}" '
                           '-f "dockerfiles/${{ matrix.dockerfile }}" .',
                },
                {
                    'name': 'Run tests',
                    'run': 'docker run -t '
                           '-e PYTHONPATH="/opt/pre/${{ matrix.product }}-'
                           '${{ matrix.version }}/lib" '
                           '-e PRE="${{ matrix.pre }}" '
                           '-e PRODUCT="${{ matrix.product }}" '
                           '-e VERSION="${{ matrix.version }}" '
                           '-e PPA="${{ matrix.ppa }}" '
                           '"aut-${{ matrix.dockerfile }}"'
                },
            ],
        },
        'notify': {
            'if': '${{ always() }}',
            'timeout-minutes': 1,
            'needs': 'build',
            'runs-on': 'ubuntu-latest',
            'steps': [
                {
                    'name': 'Notify on success',
                    'if': "${{ success() }} && github.event_name != 'schedule'",
                    'uses': 'joelwmale/webhook-action@master',
                    'with': {
                        'url': 'https://sl.da.gd/slackjack',
                        'headers': '{"repository": "relrod/aut"}',
                        'body': '{"channel": "#relrodtest", "username": "aut",'
                                '"url": "https://github.com/${{ github.repository }}'
                                '/actions/runs/${{ github.run_id }}", '
                                '"text": "aut tests passed"}',
                    },
                },
                {
                    'name': 'Notify on failure',
                    'if': "${{ failure() }}",
                    'uses': 'joelwmale/webhook-action@master',
                    'with': {
                        'url': 'https://sl.da.gd/slackjack',
                        'headers': '{"repository": "relrod/aut"}',
                        'body': '{"channel": "#relrodtest", "username": "aut",'
                                '"url": "https://github.com/${{ github.repository }}'
                                '/actions/runs/${{ github.run_id }}", '
                                '"text": "aut tests failed"}',
                    },

                },
            ],
        },
    },
}

def main():
    with open('matrix.yml', 'r') as f:
        data = yaml.safe_load(f.read())

    for dockerfile, pres in data['dockerfiles'].items():
        for pre_dict in pres:
            for pre, premeta in pre_dict.items():
                for product in ('ansible', 'ansible-base'):
                    if premeta:
                        if product in premeta.get('exclude', []):
                            continue
                    for version in data[product]:
                        matrix_entry = {
                            'dockerfile': dockerfile,
                            'version': version,
                            'product': product,
                            'pre': pre,
                        }
                        if premeta:
                            version_re = premeta.get('version_re', '')
                            if version_re and not re.search(version_re, version):
                                continue

                            if 'rc' in premeta.get('exclude', []) and 'rc' in version:
                                continue

                            env = premeta.get('env', {})
                            if env:
                                for k, v in env.items():
                                    matrix_entry[k] = v
                        YAML['jobs']['build']['strategy']['matrix']['include'].append(matrix_entry)

    print(yaml.dump(YAML))

if __name__ == '__main__':
    main()
