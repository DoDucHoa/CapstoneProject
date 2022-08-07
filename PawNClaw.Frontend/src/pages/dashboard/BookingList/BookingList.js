import { isEmpty } from 'lodash';
import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

// @mui
import { Box, Card, Container, DialogTitle, Table, TableBody, TableContainer, TablePagination } from '@mui/material';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useAuth from '../../../hooks/useAuth';
import useSettings from '../../../hooks/useSettings';
import useTable, { emptyRows } from '../../../hooks/useTable';
// redux
import { closeModal, getBookingDetails } from '../../../redux/slices/calendar';
// components
import { DialogAnimate } from '../../../components/animate';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import Page from '../../../components/Page';
import Scrollbar from '../../../components/Scrollbar';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';
import { BookingListToolbar, BookingRow } from '../../../sections/@dashboard/bookingList';
import { CalendarForm } from '../../../sections/@dashboard/calendar';
import { getBookingList } from './useBookingListAPI';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'id', label: 'Số chứng từ', align: 'left' },
  { id: 'customerName', label: 'Khách hàng', align: 'left' },
  { id: 'startBooking', label: 'Ngày đặt', align: 'center' },
  { id: 'endBooking', label: 'Ngày kết thúc', align: 'center' },
  { id: 'status', label: 'Trạng thái', align: 'left' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function BookingList() {
  // CONFIG
  const { themeStretch } = useSettings();
  const denseHeight = 72;

  // * --------------------------------------------------------------------------------------------------------------------------------------------
  // STATE
  const [fromDate, setFromDate] = useState(null);
  const [toDate, setToDate] = useState(null);
  const [bookingStatus, setBookingStatus] = useState(0);

  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});

  // * --------------------------------------------------------------------------------------------------------------------------------------------
  // REDUX
  const dispatch = useDispatch();
  const { isOpenModal, bookingDetails, bookingStatuses, petData } = useSelector((state) => state.calendar);

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
  const { centerId, centerInfo } = useAuth();

  // * --------------------------------------------------------------------------------------------------------------------------------------------
  // STARTUP
  const getBookings = async () => {
    const { data, metadata } = await getBookingList(centerId, page, rowsPerPage, bookingStatus);

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

    return () => {
      setTableData([]);
      setMetadata({});
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, rowsPerPage, bookingStatus, centerId]);

  // * --------------------------------------------------------------------------------------------------------------------------------------------
  // REDUX FUNCTION
  const handleOpenCalendarDialog = (idBooking) => {
    dispatch(getBookingDetails(idBooking));
  };

  const handleCloseModal = () => {
    dispatch(closeModal());
  };

  const isNotFound = !(metadata.totalCount ? metadata.totalCount : 0);

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
                    <BookingRow
                      key={row.id}
                      row={row}
                      onClick={handleOpenCalendarDialog}
                      bookingStatuses={bookingStatuses}
                    />
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
              count={metadata.totalCount ? metadata.totalCount : 0}
              rowsPerPage={rowsPerPage}
              page={page}
              onPageChange={onChangePage}
              onRowsPerPageChange={onChangeRowsPerPage}
            />
          </Box>
        </Card>

        <DialogAnimate open={isOpenModal} onClose={handleCloseModal}>
          <DialogTitle>Khách hàng: {isEmpty(bookingDetails) ? '' : bookingDetails.customer.name}</DialogTitle>
          <CalendarForm
            centerId={centerId}
            centerInfo={centerInfo}
            selectedEvent={bookingDetails || {}}
            onCancel={handleCloseModal}
            bookingStatuses={bookingStatuses}
            petData={petData}
            updateStatusColor={() => {}} // FIXME: fix update status for booking list
          />
        </DialogAnimate>
      </Container>
    </Page>
  );
}
