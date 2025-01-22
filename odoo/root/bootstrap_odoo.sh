#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright (c) 2025, Juan David Hurtado G <jdhurtado@orbiware.com>.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

ODOO_VERSION="${version}"
ODOO_EDITION="${edition}"
ODOO_PATH="/usr/local/odoo"
ODOO_THEMES_PATH="${ODOO_PATH}_themes"
ODOO_EE_PATH="${ODOO_PATH}_ee"

# Prepare Odoo group and user
if ! pw group show odoo >/dev/null 2>&1; then
    pw group add odoo
    echo "Group 'odoo' has been created."
else
    echo "Group 'odoo' already exists."
fi

if ! pw user show odoo >/dev/null 2>&1; then
    pw useradd odoo -g odoo -s /usr/sbin/nologin -d /nonexistent -c "Odoo user for running the app"
    echo "User 'odoo' has been created."
else
    echo "User 'odoo' already exists."
fi

# Clone needed repos
if  [ ! -d "${ODOO_PATH}" ]; then
  git clone -b "${ODOO_VERSION}" --depth 1 https://github.com/odoo/odoo.git "${ODOO_PATH}"
fi
if [ ! -d "${ODOO_THEMES_PATH}" ]; then
  git clone -b "${ODOO_VERSION}" --depth 1 https://github.com/odoo/design-themes.git "${ODOO_THEMES_PATH}"
fi
if [ "${ODOO_EDITION}" = "enterprise" ] && [ ! -d "${ODOO_EE_PATH}" ]; then
  git clone -b "${ODOO_VERSION}" --depth 1 git@github.com:odoo/enterprise.git "${ODOO_EE_PATH}"
fi

# Update code in repos
git -C "${ODOO_PATH}" pull
git -C "${ODOO_THEMES_PATH}" pull
if [ "${ODOO_EDITION}" = "enterprise" ] && [ -d "${ODOO_EE_PATH}" ]; then
  git -C "${ODOO_EE_PATH}" pull
fi

#Set permissions
chown -R odoo:odoo "${ODOO_PATH}"*
# Install missing python dependencies that where not available in PKG
# Using pyopenssl==23.2.0 because Odoo is using crypto.sign() method which is deprecated in later versions
# There is a possibility that you need to downgrade werkzeug. If so, use `pip install Werkzeug==2.0.2`
C_INCLUDE_PATH=/usr/local/include /usr/local/bin/pip install lxml_html_clean pyopenssl==23.2.0
# TODO: install submodule dependencies
