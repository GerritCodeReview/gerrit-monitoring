import argparse

from cfgmgr import get_config_manager
from installer import install, uninstall


def _run_install(args):
    install(
        get_config_manager(args.config), args.output_dir, args.dryrun, args.update_repo,
    )


def _run_uninstall(args):
    uninstall(get_config_manager(args.config))


def main():
    """Argument parser for the gerrit monitoring installer
    """
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

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
