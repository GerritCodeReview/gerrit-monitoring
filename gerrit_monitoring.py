# Copyright (C) 2020 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import os.path

from cfgmgr import get_config_manager
from subcommands import encrypt, install, uninstall


def _run_encrypt(args):
    encrypt(args.pgp_identifier, os.path.abspath(args.config))


def _run_install(args):
    install(
        get_config_manager(os.path.abspath(args.config)),
        os.path.abspath(args.output_dir),
        args.dryrun,
        args.update_repo,
    )


def _run_uninstall(args):
    uninstall(get_config_manager(args.config))


def main():
    """Argument parser for the gerrit monitoring installer."""
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-c",
        "--config",
        help="Path to configuration file.",
        dest="config",
        action="store",
        required=True,
    )

    subparsers = parser.add_subparsers()

    parser_install = subparsers.add_parser("install", help="Install Gerrit monitoring")
    parser_install.set_defaults(func=_run_install)

    parser_install.add_argument(
        "-o",
        "--output",
        help="Output directory for generated files.",
        dest="output_dir",
        action="store",
        default="./dist",
    )

    parser_install.add_argument(
        "-d",
        "--dryrun",
        help="Only generate files, but do not install them.",
        dest="dryrun",
        action="store_true",
    )

    parser.add_argument(
        "--update-repo",
        help="Update the helm repositories.",
        dest="update_repo",
        action="store_true",
    )

    parser_uninstall = subparsers.add_parser(
        "uninstall", help="Uninstall Gerrit monitoring"
    )
    parser_uninstall.set_defaults(func=_run_uninstall)

    parser_encrypt = subparsers.add_parser("encrypt", help="Encrypt config")
    parser_encrypt.set_defaults(func=_run_encrypt)

    parser_encrypt.add_argument(
        "-p",
        "--pgp",
        help="PGP fingerpint or associated email.",
        dest="pgp_identifier",
        action="store",
        required=True,
    )

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
