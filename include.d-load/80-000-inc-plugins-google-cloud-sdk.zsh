#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


#
# Source Google Cloud SDK path helper and completion scripts
#

for f in $(_cfg_get_array_values 'plugins.google_cloud_sdk.env_source_files'); do
    _check_extern_source_file "${f}" 2 'google-cloud-sdk' && source "${f}"
done

for f in $(_cfg_get_array_values 'plugins.google_cloud_sdk.completion_files'); do
    _check_extern_source_file "${f}" 2 'google-cloud-sdk' && source "${f}"
done
