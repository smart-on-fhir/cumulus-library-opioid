create table opioid__rx as
with RX as (
    SELECT core__medication.*, coding_row
    FROM
        core__medication,
        unnest(code.coding) AS t(coding_row)
)
select distinct RX.*,
        opioid__define_rx.code as rx_code,
        opioid__define_rx.system as rx_system,
        opioid__define_rx.display as rx_display
from    RX, opioid__define_rx
where   RX.coding_row.code   = opioid__define_rx.code
and     RX.coding_row.system = opioid__define_rx.system;