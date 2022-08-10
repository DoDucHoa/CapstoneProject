import PropTypes from 'prop-types';
import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

// @mui
import {
  Box,
  Tab,
  Tabs,
  Card,
  Dialog,
  Table,
  Button,
  Divider,
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
import useTabs from '../../../hooks/useTabs';
import useSettings from '../../../hooks/useSettings';
import useTable, { emptyRows } from '../../../hooks/useTable';

// components
import Page from '../../../components/Page';
import Scrollbar from '../../../components/Scrollbar';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';

// sections
import { CustomerTableRow, CustomerTableToolbar } from '../../../sections/@dashboard/customer/list';

// API
import { changeCustomerStatus, getCustomers } from './useCustomerAPI';

// ----------------------------------------------------------------------

const STATUS_OPTIONS = [
  { key: 0, value: '', label: 'Tất cả' },
  { key: 1, value: 'true', label: 'Hoạt động' },
  { key: 2, value: 'false', label: 'Đã khóa' },
];

const TABLE_HEAD = [
  { id: 'name', label: 'Họ Tên', align: 'left' },
  { id: 'email', label: 'Email', align: 'left' },
  { id: 'phone', label: 'Số điện thoại', align: 'left' },
  { id: 'status', label: 'Trạng thái', align: 'left' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function UserList() {
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});
  const [filterName, setFilterName] = useState('');
  const [searchRequest, setSearchRequest] = useState('');

  const [openDialog, setOpenDialog] = useState(false);
  const [selectIdCustomer, setSelectIdCustomer] = useState();

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

  const { currentTab: filterStatus, onChangeTab } = useTabs('');
  const onChangeFilterStatus = (event, newValue) => {
    onChangeTab(event, newValue);
    setPage(0);
  };

  const getCustomerData = async () => {
    const response = await getCustomers(page, rowsPerPage, filterStatus, searchRequest);
    const { data, metadata } = response;

    const customers = data.map((customer, index) => ({
      id: customer.id,
      avatarUrl: `https://i.pravatar.cc/150?img=${index + 1}`,
      name: customer.customer.name,
      gender: customer.customer.gender,
      birth: customer.customer.birth,
      email: customer.userName,
      phone: customer.phone,
      status: customer.status,
    }));
    setTableData(customers);
    setMetadata(metadata);
  };

  useEffect(() => {
    getCustomerData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, rowsPerPage, filterStatus, searchRequest]);

  const { themeStretch } = useSettings();

  const navigate = useNavigate();

  const handleFilterName = (filterName) => {
    setFilterName(filterName);
  };

  const handleSearchRequest = (name) => {
    setSearchRequest(name);
    setPage(0);
  };

  const handleEditRow = (id) => {
    navigate(PATH_DASHBOARD.admin.edit(id));
  };

  const handleOpenBanDialog = (idCustomer) => {
    setSelectIdCustomer(idCustomer);
    setOpenDialog(true);
  };

  const handleCloseBanDialog = () => {
    setOpenDialog(false);
  };

  const handleUnbanCustomer = async (id) => {
    await changeCustomerStatus(id);
    await getCustomerData();
  };

  const handleBanCustomer = async (id) => {
    await changeCustomerStatus(id);
    await getCustomerData();
  };

  const denseHeight = 72;

  const isNotFound =
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!filterName) ||
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!filterStatus);

  return (
    <>
      <Page title="Khách hàng">
        <Container maxWidth={themeStretch ? false : 'lg'}>
          <HeaderBreadcrumbs
            heading="Danh sách khách hàng"
            links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Danh sách khách hàng' }]}
          />

          <Card>
            <Tabs
              allowScrollButtonsMobile
              variant="scrollable"
              scrollButtons="auto"
              value={filterStatus}
              onChange={onChangeFilterStatus}
              sx={{ px: 2, bgcolor: 'background.neutral' }}
            >
              {STATUS_OPTIONS.map((tab) => (
                <Tab disableRipple key={tab.key} label={tab.label} value={tab.value} />
              ))}
            </Tabs>

            <Divider />

            <CustomerTableToolbar
              filterName={filterName}
              onFilterName={handleFilterName}
              onEnterPress={handleSearchRequest}
            />

            <Scrollbar>
              <TableContainer sx={{ minWidth: 800, position: 'relative' }}>
                <Table size={'medium'}>
                  <TableHeadCustom order={order} orderBy={orderBy} headLabel={TABLE_HEAD} onSort={onSort} />

                  <TableBody>
                    {tableData.map((row) => (
                      <CustomerTableRow
                        key={row.id}
                        row={row}
                        onEditRow={() => handleEditRow(row.id)}
                        onDeleteRow={() => (row.status ? handleOpenBanDialog(row.id) : handleUnbanCustomer(row.id))}
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

      <BanCustomerDialog
        open={openDialog}
        onClose={handleCloseBanDialog}
        idCustomer={selectIdCustomer}
        handleBanCustomer={handleBanCustomer}
      />
    </>
  );
}

// ----------------------------------------------------------------------

BanCustomerDialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
  idCustomer: PropTypes.number,
  handleBanCustomer: PropTypes.func,
};

function BanCustomerDialog({ open, onClose, idCustomer, handleBanCustomer }) {
  const onConfirm = () => {
    handleBanCustomer(idCustomer);
    onClose();
  };

  return (
    <Dialog open={open} maxWidth="xs" onClose={onClose}>
      <DialogTitle>Bạn có chắc chắn muốn khóa người này?</DialogTitle>
      <DialogContent>
        <Typography variant="body2" sx={{ color: 'text.secondary' }}>
          Bạn vẫn có thể mở khóa người này sau khi xác nhận!
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
