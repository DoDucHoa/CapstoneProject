import PropTypes from 'prop-types';
import { useState, useEffect } from 'react';
import { Link as RouterLink, useNavigate } from 'react-router-dom';

// @mui
import {
  Box,
  Card,
  Dialog,
  Table,
  Button,
  TableBody,
  Container,
  TableContainer,
  TablePagination,
  DialogTitle,
  DialogActions,
  Typography,
  DialogContent,
} from '@mui/material';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useSettings from '../../../hooks/useSettings';
import useTable, { emptyRows } from '../../../hooks/useTable';
import useAuth from '../../../hooks/useAuth';

// components
import Page from '../../../components/Page';
import Iconify from '../../../components/Iconify';
import Scrollbar from '../../../components/Scrollbar';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';

// sections
import { VoucherTableRow, VoucherTableToolbar } from '../../../sections/@dashboard/voucher/list';

// API
import { getVouchers, banVoucher, getVoucherType } from './useVoucherAPI';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'code', label: 'Mã voucher', align: 'left' },
  { id: 'description', label: 'Diễn giải', align: 'left' },
  { id: 'voucherTypeCode', label: 'Loại voucher', align: 'left' },
  { id: 'value', label: 'Giá trị', align: 'right' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function UserList() {
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});
  const [filterName, setFilterName] = useState('');
  const [searchRequest, setSearchRequest] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectCodeVoucher, setSelectCodeVoucher] = useState();
  const [voucherType, setVoucherType] = useState([]);

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

  const getVoucherData = async () => {
    const response = await getVouchers(page, rowsPerPage, centerId);
    const { data, metadata } = response;

    const vouchers = data.map((voucher) => ({
      code: voucher.code,
      voucherType: voucher.voucherTypeCode,
      value: voucher.value,
      description: voucher.description,
    }));
    setTableData(vouchers);
    setMetadata(metadata);
  };

  useEffect(() => {
    getVoucherData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, rowsPerPage, searchRequest]);

  useEffect(() => {
    getVoucherType().then((res) => {
      setVoucherType(res);
    });
  }, []);

  const { themeStretch } = useSettings();
  const { centerId } = useAuth();
  const navigate = useNavigate();

  const handleFilterName = (filterName) => {
    setFilterName(filterName);
  };

  const handleSearchRequest = (name) => {
    setSearchRequest(name);
    setPage(0);
  };

  const handleEditRow = (code) => {
    navigate(PATH_DASHBOARD.voucher.edit(code));
  };

  const handleBanVoucher = async (code) => {
    await banVoucher(code);
    await getVoucherData();
  };

  const handleOpenBanDialog = (codeVoucher) => {
    setSelectCodeVoucher(codeVoucher);
    setOpenDialog(true);
  };

  const handleCloseBanDialog = () => {
    setOpenDialog(false);
  };

  const denseHeight = 72;

  const isNotFound = !(metadata.totalCount ? metadata.totalCount : 0) && !!filterName;

  return (
    <>
      <Page title="Voucher">
        <Container maxWidth={themeStretch ? false : 'lg'}>
          <HeaderBreadcrumbs
            heading="Danh sách voucher"
            links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Danh sách voucher' }]}
            action={
              <Button
                variant="contained"
                component={RouterLink}
                to={PATH_DASHBOARD.voucher.new}
                startIcon={<Iconify icon={'eva:plus-fill'} />}
              >
                Thêm mới voucher
              </Button>
            }
          />

          <Card>
            {/* Filter dữ liệu */}
            <VoucherTableToolbar
              filterName={filterName}
              onFilterName={handleFilterName}
              onEnterPress={handleSearchRequest}
            />

            {/* Scrollbar dùng để tạo scroll ngang cho giao diện điện thoại */}
            <Scrollbar>
              <TableContainer sx={{ minWidth: 800, position: 'relative' }}>
                <Table size={'medium'}>
                  <TableHeadCustom order={order} orderBy={orderBy} headLabel={TABLE_HEAD} onSort={onSort} />

                  <TableBody>
                    {tableData.map((row) => (
                      <VoucherTableRow
                        key={row.code}
                        row={row}
                        onEditRow={() => handleEditRow(row.code)}
                        onDeleteRow={() => handleOpenBanDialog(row.code)}
                        voucherTypes={voucherType}
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
        </Container>
      </Page>

      <BanVoucherDialog
        open={openDialog}
        onClose={handleCloseBanDialog}
        codeVoucher={selectCodeVoucher}
        handleBanVoucher={handleBanVoucher}
      />
    </>
  );
}

// ----------------------------------------------------------------------
BanVoucherDialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
  codeVoucher: PropTypes.string,
  handleBanVoucher: PropTypes.func,
};

function BanVoucherDialog({ open, onClose, codeVoucher, handleBanVoucher }) {
  const onConfirm = () => {
    handleBanVoucher(codeVoucher);
    onClose();
  };

  return (
    <Dialog open={open} maxWidth="xs" onClose={onClose}>
      <DialogTitle>Bạn có chắc chắn muốn voucher này?</DialogTitle>
      <DialogContent>
        <Typography variant="body2" sx={{ color: 'text.secondary' }}>
          Bạn không thể khôi phục sau khi xóa!
        </Typography>
      </DialogContent>
      <DialogActions>
        <Button color="error" onClick={onClose}>
          Hủy
        </Button>
        <Button color="primary" onClick={onConfirm} autoFocus>
          Xác Nhận
        </Button>
      </DialogActions>
    </Dialog>
  );
}
