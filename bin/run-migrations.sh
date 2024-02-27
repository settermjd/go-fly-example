#!/bin/sh

set -u

echo "Provisioning the database...."

# Check if the database URL is both set *and* not empty.
if [ -z "${DATABASE_URL:-}" ]; then
    echo "Database URL is not available. Please set it. Exiting...."
    exit 1
fi

# Extract the database directory from the DATABASE_URL environment variable
db_url_prefix="sqlite:"
db_dir=$(dirname ${DATABASE_URL#"$db_url_prefix"})

# Create the database directory if it does not exist.
if [ ! -d $db_dir ]; then
    echo "Database directory [ ${db_dir} ] does not exist. Creating...."
    mkdir -p "$db_dir"
fi

# Run any pending migrations
# 1 is returned if there are pending migrations
# 0 is returned if there are no pending migrations
npx dbmate status --exit-code --quiet
no_migrations=$?
if [ ! $no_migrations ]; then
    echo "Running pending migrations...."
    npx dbmate up
fi

echo "....Finished provisioning the database."

exit 0