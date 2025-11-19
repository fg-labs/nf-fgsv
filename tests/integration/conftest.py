import os
import pytest


def pytest_addoption(parser: pytest.Parser) -> None:
    parser.addoption(
        "--nf_profile",
        action="store",
        default="docker,test",
        help="Nextflow profiles to use for test execution",
    )


def pytest_configure(config: pytest.Config) -> None:
    os.environ["PROFILES"] = config.getoption("nf_profile")
