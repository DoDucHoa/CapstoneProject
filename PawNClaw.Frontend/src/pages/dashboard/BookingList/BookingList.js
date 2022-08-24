import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router';

// @mui
import { Box, Card, Container, Table, TableBody, TableContainer, TablePagination } from '@mui/material';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useAuth from '../../../hooks/useAuth';
import useSettings from '../../../hooks/useSettings';
import useTable, { emptyRows } from '../../../hooks/useTable';
import { useDispatch } from '../../../redux/store';
// components
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import Page from '../../../components/Page';
import Scrollbar from '../../../components/Scrollbar';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';
import { BookingListToolbar, BookingRow } from '../../../sections/@dashboard/bookingList';
import { getBookingList } from './useBookingListAPI';
import { resetEvent } from '../../../redux/slices/calendar';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'id', label: 'Đơn hàng', align: 'left' },
  { id: 'customerName', label: 'Khách hàng', align: 'left' },
  { id: 'startBooking', label: 'Ngày đặt', align: 'center' },
  { id: 'endBooking', label: 'Ngày kết thúc', align: 'center' },
  { id: 'status', label: 'Trạng thái', align: 'left' },
];

// ----------------------------------------------------------------------

export default function BookingList() {
  // CONFIG
  const { themeStretch } = useSettings();
  const dispatch = useDispatch();
  const denseHeight = 72;

  // * --------------------------------------------------------------------------------------------------------------------------------------------
  // STATE
  const [fromDate, setFromDate] = useState(null);
  const [toDate, setToDate] = useState(null);
  const [bookingStatus, setBookingStatus] = useState(0);

  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});

  // * --------------------------------------------------------------------------------------------------------------------------------------------
  // HOOKS
  const {
    page,
    order,
    orderBy,
    rowsPerPage,
    //
    onSort,
    onChangePage,
    onChangeRowsPerPage,
  } = useTable();
  const { centerId } = useAuth();
  const navigate = useNavigate();

  // * --------------------------------------------------------------------------------------------------------------------------------------------
  // STARTUP
  const getBookings = async () => {
    const { data, metadata } = await getBookingList(centerId, page, rowsPerPage, bookingStatus, fromDate, toDate);

    const bookingList = data.map((booking) => ({
      id: booking.id,
      customerName: booking.customer.name,
      startBooking: booking.startBooking,
      endBooking: booking.endBooking,
      status: booking.status,
    }));

    setTableData(bookingList);
    setMetadata(metadata);
  };

  useEffect(() => {
    getBookings();
    dispatch(resetEvent());

    return () => {
      setTableData([]);
      setMetadata({});
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, rowsPerPage, bookingStatus, centerId, fromDate, toDate]);

  // * --------------------------------------------------------------------------------------------------------------------------------------------
  // REDUX FUNCTION
  const navigateToBookingDetail = (idBooking) => {
    navigate(PATH_DASHBOARD.bookingDetail.bookingList(idBooking));
  };

  const isNotFound = !(metadata.totalCount ? metadata.totalCount : 0);

  return (
    <Page title="Đơn hàng">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Đơn hàng"
          links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Đơn hàng' }]}
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
                    <BookingRow key={row.id} row={row} onClick={navigateToBookingDetail} />
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

          <Box sx={{ position: 'relative' }}>
            <TablePagination
              labelRowsPerPage="Số dòng trên trang"
              labelDisplayedRows={({ from, to, count }) => `${from} đến ${to} trên ${count}`}
              rowsPerPageOptions={[5, 10, 15, 20]}
              component="div"
              count={metadata?.totalCount ? metadata?.totalCount : 0}
              rowsPerPage={rowsPerPage}
              page={page}
              onPageChange={onChangePage}
              onRowsPerPageChange={onChangeRowsPerPage}
            />
          </Box>
        </Card>
      </Container>
    </Page>
  );
}
