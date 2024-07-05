import pathlib
import shutil

import pytest
from cumulus_library import study_manifest

from cumulus_library_opioid.vocab import static_builder


@pytest.mark.parametrize(
    "filtered,ignore_header,mapping,expected",
    [
        (
            None,
            False,
            None,
            {
                "headers": ["foo", "bar"],
                "data": [
                    ("header_1", "header_2"),
                    ("val_1", "val_2"),
                    ("val_3", "val_4"),
                ],
            },
        ),
        (
            "filtered.csv",
            False,
            None,
            {"headers": ["foo", "bar"], "data": [("val_2", None)]},
        ),
        (
            None,
            True,
            None,
            {
                "headers": ["foo", "bar"],
                "data": [("val_1", "val_2"), ("val_3", "val_4")],
            },
        ),
        (
            None,
            None,
            [{"from": "bar", "to": "baz", "map_dict": {"val_2": "val_5"}}],
            {
                "headers": ["foo", "bar", "baz"],
                "data": [
                    ("header_1", "header_2", None),
                    ("val_1", "val_2", "val_5"),
                    ("val_3", "val_4", None),
                ],
            },
        ),
    ],
)
def test_static_tables(
    tmp_path, mock_db_config, filtered, ignore_header, mapping, expected
):
    test_path = pathlib.Path(__file__).parent / "test_data/static"
    shutil.copy(test_path / "static_table.csv", tmp_path / "static_table.csv")
    shutil.copy(test_path / "filtered.csv", tmp_path / "filtered.csv")
    builder = static_builder.StaticBuilder()
    filtered = tmp_path / filtered if filtered else None
    builder.tables = [
        static_builder.TableConfig(
            file_path=tmp_path / "static_table.csv",
            delimiter=",",
            table_name="test_table",
            headers=["foo", "bar"],
            dtypes={"foo": "str", "bar": "str"},
            parquet_types=["STR", "STR"],
            filtered_name=filtered,
            ignore_header=ignore_header,
            map_cols=mapping,
        )
    ]
    builder.execute_queries(
        config=mock_db_config, manifest=study_manifest.StudyManifest(test_path)
    )
    result = mock_db_config.db.cursor().execute("select * from test__test_table")
    cols = [col[0] for col in result.description]
    assert cols == expected["headers"]
    assert result.fetchall() == expected["data"]
