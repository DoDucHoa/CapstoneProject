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
import { CageTypeTableRow, CageTypeTableToolbar } from '../../../sections/@dashboard/cageType/list';

// API
import { getCageTypes, banCageType, unbanCageType } from './useCageTypeAPI';

// ----------------------------------------------------------------------

const STATUS_OPTIONS = [
  { key: 0, value: '', label: 'Tất cả' },
  { key: 1, value: 'true', label: 'Hoạt động' },
  { key: 2, value: 'false', label: 'Đã khóa' },
];

const TABLE_HEAD = [
  { id: 'name', label: 'Tên loại chuồng', align: 'left' },
  { id: 'height', label: 'Chiều cao (cm)', align: 'right' },
  { id: 'width', label: 'Chiều rộng (cm)', align: 'right' },
  { id: 'length', label: 'Chiều dài (cm)', align: 'right' },
  { id: 'isSingle', label: 'Chuồng riêng', align: 'center' },
  { id: 'status', label: 'Trạng thái', align: 'left' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function CageTypeList() {
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});
  const [filterName, setFilterName] = useState('');
  const [searchRequest, setSearchRequest] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectIdAdmin, setSelectIdAdmin] = useState();

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

  const { centerId } = useAuth();
  const { currentTab: filterStatus, onChangeTab } = useTabs('');
  const onChangeFilterStatus = (event, newValue) => {
    onChangeTab(event, newValue);
    setPage(0);
  };

  const getCageTypeData = async () => {
    const response = await getCageTypes(centerId, page, rowsPerPage, filterStatus, searchRequest);

    const { data, metadata } = response;

    const cageTypes = data.map((cageType) => ({
      id: cageType.id,
      name: cageType.typeName,
      height: cageType.height,
      width: cageType.width,
      length: cageType.length,
      isSingle: cageType.isSingle,
      status: cageType.status,
    }));
    setTableData(cageTypes);
    setMetadata(metadata);
  };

  useEffect(() => {
    getCageTypeData();
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
    navigate(PATH_DASHBOARD.cageType.edit(id));
  };

  const handleBanAdmin = async (id) => {
    await banCageType(id);
    await getCageTypeData();
  };

  const handleUnbanAdmin = async (id) => {
    await unbanCageType(id);
    await getCageTypeData();
  };
  const handleOpenBanDialog = (idAdmin) => {
    setSelectIdAdmin(idAdmin);
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
      <Page title="Loại chuồng">
        <Container maxWidth={themeStretch ? false : 'lg'}>
          <HeaderBreadcrumbs
            heading="Danh sách loại chuồng"
            links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Danh sách loại chuồng' }]}
            action={
              <Button
                variant="contained"
                component={RouterLink}
                to={PATH_DASHBOARD.cageType.new}
                startIcon={<Iconify icon={'eva:plus-fill'} />}
              >
                Thêm mới loại chuồng
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
            <CageTypeTableToolbar
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
                      <CageTypeTableRow
                        key={row.id}
                        row={row}
                        onEditRow={() => handleEditRow(row.id)}
                        onDeleteRow={() => (row.status ? handleOpenBanDialog(row.id) : handleUnbanAdmin(row.id))}
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
      <BanAdminDialog
        open={openDialog}
        onClose={handleCloseBanDialog}
        idAdmin={selectIdAdmin}
        handleBanAdmin={handleBanAdmin}
      />
    </>
  );
}

// ----------------------------------------------------------------------
BanAdminDialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
  idAdmin: PropTypes.number,
  handleBanAdmin: PropTypes.func,
};

function BanAdminDialog({ open, onClose, idAdmin, handleBanAdmin }) {
  const onConfirm = () => {
    handleBanAdmin(idAdmin);
    onClose();
  };

  return (
    <Dialog open={open} maxWidth="xs" onClose={onClose}>
      <DialogTitle>Bạn có chắc chắn muốn khóa loại chuồng?</DialogTitle>
      <DialogContent>
        <Typography variant="body2" sx={{ color: 'text.secondary' }}>
          Bạn vẫn có thể mở khóa loại chuồng này sau khi xác nhận!
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
