eval "$(/opt/homebrew/bin/brew shellenv)"

# Setting PATH for Python 3.10
# The original version is saved in /Volumes/El Gato/External Mac/.zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

# Use PostgreSQL 17 client tools (psql/pg_dump) to match Railway's PG 17.
# Must come AFTER brew shellenv so it beats the libpq 18 keg in /opt/homebrew/bin.
export PATH="/opt/homebrew/opt/postgresql@17/bin:${PATH}"


# Added by Antigravity CLI installer
export PATH="/Volumes/El Gato/External Mac/.local/bin:$PATH"
