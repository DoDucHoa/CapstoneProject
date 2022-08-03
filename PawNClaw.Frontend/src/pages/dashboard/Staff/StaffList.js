import PropTypes from 'prop-types';
import { useState, useEffect } from 'react';
import { Link as RouterLink, useNavigate } from 'react-router-dom';

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
import useAuth from '../../../hooks/useAuth';

// components
import Page from '../../../components/Page';
import Iconify from '../../../components/Iconify';
import Scrollbar from '../../../components/Scrollbar';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';

// sections
import { StaffTableRow, StaffTableToolbar } from '../../../sections/@dashboard/staff/list';

// API
import { getStaffs, banStaff } from './useStaffAPI';

// ----------------------------------------------------------------------

const STATUS_OPTIONS = [
  { key: 0, value: '', label: 'Tất cả' },
  { key: 1, value: 'true', label: 'Hoạt động' },
  { key: 2, value: 'false', label: 'Đã khóa' },
];

const TABLE_HEAD = [
  { id: 'name', label: 'Họ Tên', align: 'left' },
  { id: 'userName', label: 'Email', align: 'left' },
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
  const [selectIdStaff, setSelectIdStaff] = useState();

  const { themeStretch } = useSettings();
  const { centerId } = useAuth();
  const navigate = useNavigate();

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

  const getStaffData = async () => {
    const response = await getStaffs(centerId, page, rowsPerPage, filterStatus, searchRequest);
    const { data, metadata } = response;

    const staffs = data.map((staff) => ({
      id: staff.id,
      photoUrl: staff?.photos?.length > 0 ? staff?.photos[0].url : '',
      name: staff.name,
      userName: staff.idNavigation.userName,
      phone: staff.idNavigation.phone,
      status: staff.idNavigation.status,
      createUser: staff.createUser,
    }));
    setTableData(staffs);
    setMetadata(metadata);
  };

  useEffect(() => {
    getStaffData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [centerId, page, rowsPerPage, filterStatus, searchRequest]);

  const handleFilterName = (filterName) => {
    setFilterName(filterName);
  };

  const handleSearchRequest = (name) => {
    setSearchRequest(name);
    setPage(0);
  };

  const handleEditRow = (id) => {
    navigate(PATH_DASHBOARD.staff.edit(id));
  };

  const handleBanStaff = async (id) => {
    await banStaff(id);
    await getStaffData();
  };

  const handleOpenBanDialog = (idStaff) => {
    setSelectIdStaff(idStaff);
    setOpenDialog(true);
  };

  const handleCloseBanDialog = () => {
    setOpenDialog(false);
  };

  const denseHeight = 72;

  const isNotFound =
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!filterName) ||
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!filterStatus);

  return (
    <>
      <Page title="Nhân viên">
        <Container maxWidth={themeStretch ? false : 'lg'}>
          <HeaderBreadcrumbs
            heading="Danh sách nhân viên"
            links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Danh sách nhân viên' }]}
            action={
              <Button
                variant="contained"
                component={RouterLink}
                to={PATH_DASHBOARD.staff.new}
                startIcon={<Iconify icon={'eva:plus-fill'} />}
              >
                Thêm mới nhân viên
              </Button>
            }
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

            {/* Filter dữ liệu */}
            <StaffTableToolbar
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
                      <StaffTableRow
                        key={row.id}
                        row={row}
                        onEditRow={() => handleEditRow(row.id)}
                        onDeleteRow={() => handleOpenBanDialog(row.id)}
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

      <BanStaffDialog
        open={openDialog}
        onClose={handleCloseBanDialog}
        idStaff={selectIdStaff}
        handleBanStaff={handleBanStaff}
      />
    </>
  );
}

// ----------------------------------------------------------------------
BanStaffDialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
  idStaff: PropTypes.number,
  handleBanStaff: PropTypes.func,
};

function BanStaffDialog({ open, onClose, idStaff, handleBanStaff }) {
  const onConfirm = () => {
    handleBanStaff(idStaff);
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
