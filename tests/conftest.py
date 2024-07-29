import pathlib

import pytest
from cumulus_library import base_utils, databases


@pytest.fixture
def mock_db(tmp_path):
    """Provides a DuckDatabaseBackend for local testing"""
    db, _ = databases.create_db_backend(
        {
            "db_type": "duckdb",
            "database": f"{tmp_path}/duck.db",
            # "load_ndjson_dir": MOCK_DATA_DIR,
        }
    )
    yield db


@pytest.fixture
def mock_db_config(mock_db):
    """Provides a DuckDatabaseBackend for local testing inside a StudyConfig"""
    config = base_utils.StudyConfig(db=mock_db, schema="main")
    yield config


@pytest.fixture
def mock_db_config_rxnorm(mock_db):
    config = base_utils.StudyConfig(db=mock_db, schema="main")
    config.options = { 'steward':'acep' }
    cursor = config.db.cursor()
    mock_rxnorm_data = list((pathlib.Path(__file__).parent / 'test_data').glob('*.csv'))
    cursor = config.db.cursor()
    cursor.execute("CREATE SCHEMA rxnorm")
    for table in mock_rxnorm_data:
        cursor.execute(
            f"CREATE TABLE rxnorm.{table.stem} AS SELECT * FROM read_csv('{table}')"
        )
    yield config