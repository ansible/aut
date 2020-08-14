# aut

ansible user tests - aka testing user-facing artifacts

This is a series of tests that release engineers can run to test release
artifacts and ensure, on a very basic level, that they work as expected in
most situations.

* `dockerfiles` contains basic dockerfiles which install enough pre-reqs to
  make the scripts in `pre` work.

* `pre` contains scripts that have various ways to install `ansible` and/or
  `ansible-base`.

* `run` contains a series of tests which get run after a script in `pre` is
  executed to install Ansible.

* `matrix.yml` describes the test matrix

* `build-matrix.py` generates `env` lines for `.travis.yml`
