#!/usr/bin/env bash
#
# Test the OpenLDAP image.
#
# IMAGE specifies the test_name of the candidate image used for testing.
# The image has to be available before this script is executed.
#

set -eo nounset
shopt -s nullglob

function test_openldap() {
  echo "  Testing OpenLDAP"

  ldapsearch -x -LLL \
    -h "$server_name" -p 389 \
    -b dc=example,dc=com objectClass=organization \
    | grep "dc=example,dc=com"

  ldapadd -x \
    -h "$server_name" -p 389 \
    -D cn=Manager,dc=example,dc=com -w admin \
    -f test/test.ldif

  ldapsearch -x -LLL \
    -h "$server_name" -p 389 \
    -b cn=person,dc=example,dc=com memberof \
    | grep "dc=example,dc=com"

  echo "  Success!"
}

test_openldap
