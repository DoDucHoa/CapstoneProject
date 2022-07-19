import { useState } from 'react';
import { useSelector } from 'react-redux';

// @mui
import { Box, Card, Container, Table, TableBody, TableContainer } from '@mui/material';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useSettings from '../../../hooks/useSettings';
import useTable, { emptyRows } from '../../../hooks/useTable';

// components
import Page from '../../../components/Page';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import Scrollbar from '../../../components/Scrollbar';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';
import { BookingRow, BookingListToolbar } from '../../../sections/@dashboard/bookingList';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'name', label: 'Tên thương thiệu', align: 'left' },
  { id: 'description', label: 'Mô tả', align: 'left' },
  { id: 'ownerName', label: 'Chủ sở hữu', align: 'left' },
  { id: 'status', label: 'Trạng thái', align: 'left' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function BookingList() {
  // STATE
  const [fromDate, setFromDate] = useState(null);
  const [toDate, setToDate] = useState(null);
  const [bookingStatus, setBookingStatus] = useState(3);

  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});
  const [filterName, setFilterName] = useState('');
  const [searchRequest, setSearchRequest] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectIdAdmin, setSelectIdAdmin] = useState();

  const { events, isOpenModal, bookingDetails, bookingStatuses, petData } = useSelector((state) => state.calendar);

  // CONFIG
  const { themeStretch } = useSettings();
  const denseHeight = 72;

  const {
    page,
    order,
    orderBy,
    rowsPerPage,
    setPage,
    //
    onSort,
    onChangePage,
    onChangeRowsPerPage,
  } = useTable();

  const isNotFound =
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!filterName) ||
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!bookingStatus);

  return (
    <Page title="Đơn booking">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Đơn booking"
          links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Đơn booking' }]}
        />

        <BookingListToolbar
          fromDate={fromDate}
          setFromDate={setFromDate}
          toDate={toDate}
          setToDate={setToDate}
          bookingStatus={bookingStatus}
          setBookingStatus={setBookingStatus}
        />

        <Box mt={4} />

        <Card sx={{ p: 1 }}>
          <Scrollbar>
            <TableContainer sx={{ minWidth: 800, position: 'relative' }}>
              <Table size={'medium'}>
                <TableHeadCustom order={order} orderBy={orderBy} headLabel={TABLE_HEAD} onSort={onSort} />

                <TableBody>
                  {tableData.map((row) => (
                    <BookingRow key={row.id} row={row} />
                  ))}

                  <TableEmptyRows
                    height={denseHeight}
                    emptyRows={emptyRows(page, rowsPerPage, metadata.totalCount ? metadata.totalCount : 0)}
                  />

                  <TableNoData isNotFound={isNotFound} />
                </TableBody>
              </Table>
            </TableContainer>
          </Scrollbar>
        </Card>
      </Container>
    </Page>
  );
}
