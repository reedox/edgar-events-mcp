# EDGAR Events MCP server — structured SEC EDGAR filing events (resolved SC 13D
# activist stakes, typed 8-K / S-1 / merger filings) over stdio.
# https://edgarevents.com
#
# The server speaks the Model Context Protocol over stdin/stdout. A host (Claude
# Desktop, Cursor, the Glama sandbox, etc.) runs the container and drives the
# initialize / tools/list handshake on the pipe.
FROM python:3.12-slim

# Unbuffered stdio so JSON-RPC frames are not held back in a pipe buffer.
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app
COPY . /app

RUN pip install .

# Drop privileges; the server needs no write access at runtime.
RUN useradd --create-home --uid 10001 app
USER app

# Console script installed by pyproject [project.scripts]. Runs mcp.run() (stdio).
ENTRYPOINT ["edgar-events-mcp"]
