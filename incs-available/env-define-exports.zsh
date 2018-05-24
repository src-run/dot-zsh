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
# Loop though exports array and export 'em.
#

for e in "${D_ZSH_LIST_EXPORT[@]}"; do
  export "${e}" \
  	&& _actLog "Variable export '${e}'" \
  	|| _dzsh_warning "Failed to export '${e}' variable"
done

# EOF
