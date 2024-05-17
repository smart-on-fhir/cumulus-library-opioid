def file_header() -> str:
    return linebreak() + "-- file_sql.py -- " + linebreak()


def linebreak(seperator="-- #########################################") -> str:
    return "\n" + seperator + "\n"


def create(tablename: str) -> str:
    _sql = [
        f"drop   table if exists   {tablename};",
        f"create table             {tablename}",
    ]
    return "\n".join(_sql)


def index(tablename: str, columns) -> str:
    return f"call create_index('{tablename}', '{columns}');"


def str_like(keywords) -> str:
    if isinstance(keywords, list):
        return "OR".join([str_like(k) for k in keywords])
    else:
        return f" (lower(STR) like lower('%{keywords}%')) "


def tic(word) -> str:
    if isinstance(word, list):
        return ",".join([tic(w) for w in word])
    else:
        return f"'{word}'"
