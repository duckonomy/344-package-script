from setuptools import setup, find_packages

setup(
    name='aima',
    version='1.0.0',
    packages=find_packages(include=['aima']),
    install_requires=['networkx==1.11', 'jupyter', 'tqdm', 'numpy'],
)
