# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -n "$IS_OSX" ]; then
        # Override pandas' default minimum MACOSX_DEPLOYEMENT_TARGET=10.9,
        # so we can build for older Pythons if we really want to.
        # See https://github.com/pandas-dev/pandas/pull/24274
        local _plat=$(get_distutils_platform)
        if [[ -z $MACOSX_DEPLOYMENT_TARGET && "$_plat" =~ macosx-(10\.[0-9]+)-.* ]]; then
            export MACOSX_DEPLOYMENT_TARGET=${BASH_REMATCH[1]}
        fi
    fi
}

function build_wheel {
    # Override common_utils build_wheel function to fix version error
    # Version error due to versioneer inside submodule
    build_bdist_wheel $@
}


function run_tests {
    # Runs tests on installed distribution from an empty directory
    export PYTHONHASHSEED=$(python -c 'import random; print(random.randint(1, 4294967295))')
    echo $PATH
    echo ${MB_PYTHON_VERSION}
    which -a python
    pip list
    python -c 'import pandas; pandas.show_versions()'
    # Skip test_float_precision_options: https://github.com/pandas-dev/pandas/issues/36429
    # Skip test_rolling_var_numerical_issues: https://github.com/pandas-dev/pandas/issues/37398
    # Skip test_rolling_skew_kurt_large_value_range: https://github.com/pandas-dev/pandas/issues/37398
    # Skip test_pairwise_with_self/test_no_pairwise_with_self: https://github.com/pandas-dev/pandas/issues/39553
    # Skip reduction tests and window test corr_sanity due to numpy issues: https://github.com/pandas-dev/pandas/issues/41935
    if [[ "$MB_PYTHON_VERSION" == "3.10" ]]; then
        python -c 'import pandas; pandas.test(extra_args=["-m not clipboard", "--skip-slow", "--skip-network", "--skip-db", "-n=2", "-k not test_rolling_var_numerical_issues and not test_rolling_skew_kurt_large_value_range and not test_float_precision_options and not test_pairwise_with_self and not test_no_pairwise_with_self and not test_corr_sanity and not TestReductions and not TestIndexReductions and not test_searchsorted and not test_replace_with_compiled_regex"])'
    else
        python -c 'import pandas; pandas.test(extra_args=["-m not clipboard", "--skip-slow", "--skip-network", "--skip-db", "-n=2", "-k not test_rolling_var_numerical_issues and not test_rolling_skew_kurt_large_value_range and not test_float_precision_options and not test_pairwise_with_self and not test_no_pairwise_with_self"])'
    fi
}
