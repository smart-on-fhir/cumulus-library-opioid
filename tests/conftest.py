import pytest

from cumulus_library import base_utils, databases

@pytest.fixture
def mock_db(tmp_path):
    """Provides a DuckDatabaseBackend for local testing"""
    db = databases.create_db_backend(
        {
            "db_type": "duckdb",
            "schema_name": f"{tmp_path}/duck.db",
            #"load_ndjson_dir": MOCK_DATA_DIR,
        }
    )
    yield db


@pytest.fixture
def mock_db_config(mock_db):
    """Provides a DuckDatabaseBackend for local testing inside a StudyConfig"""
    config = base_utils.StudyConfig(db=mock_db, schema="main")
    yield config