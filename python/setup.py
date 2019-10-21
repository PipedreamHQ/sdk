import sys

from setuptools import setup
from setuptools.command.test import test as TestCommand


class PyTest(TestCommand):
    def run_tests(self):
        import pytest

        errno = pytest.main()
        sys.exit(errno)


setup(
    name='Pipedream SDK',
    version='0.0.1dev0',
    description='The Pipedream SDK',
    url='https://github.com/PipedreamHQ/sdk',
    classifiers=(
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: Implementation :: CPython',
        'Programming Language :: Python :: Implementation :: PyPy',
    ),
    install_requires=(
        'requests>=2.22',
    ),
    tests_require=(
        'pytest>=5.2'
    ),
    cmdclass={'test': PyTest},
)
