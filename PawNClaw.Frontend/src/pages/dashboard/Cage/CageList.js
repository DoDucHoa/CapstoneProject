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
import { CageTableRow, CageTableToolbar } from '../../../sections/@dashboard/cage/list';

// API
import { getCages, banCage, unbanCage, getCageTypes } from './useCageAPI';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'code', label: 'Mã chuồng', align: 'left' },
  { id: 'typeName', label: 'Loại chuồng', align: 'left' },
  { id: 'isSingle', label: 'Chuồng riêng', align: 'center' },
  { id: 'status', label: 'Trạng thái', align: 'left' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function CageList() {
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});
  const [openDialog, setOpenDialog] = useState(false);
  const [selectIdAdmin, setSelectIdAdmin] = useState();
  const [cageTypes, setCageTypes] = useState([]); // load cage type for filter combobox

  const [filterCageCode, setFilterCageCode] = useState('');
  const [selectedCageType, setSelectedCageType] = useState(0);
  const [filterIsOnline, setFilterIsOnline] = useState(3);
  const [searchParam, setSearchParam] = useState({});

  const { centerId } = useAuth();

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

  const getCageData = async () => {
    const response = await getCages(centerId, page, rowsPerPage, filterCageCode, filterIsOnline, selectedCageType);
    const { data, metadata } = response;

    const cages = data.map((cage, index) => ({
      code: cage.code,
      avatarUrl: `https://i.pravatar.cc/150?img=${index + 1}`,
      isSingle: cage.cageType.isSingle,
      typeName: cage.cageType.typeName,
      isOnline: cage.isOnline,
      canShift: cage.canShift,
      status: cage.status,
    }));
    setTableData(cages);
    setMetadata(metadata);
  };

  // get cage list
  useEffect(() => {
    getCageData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, rowsPerPage, searchParam]);

  // get cage types
  useEffect(() => {
    getCageTypes(centerId).then((response) => {
      setCageTypes(response.data);
    });
  }, [centerId]);

  const { themeStretch } = useSettings();

  const navigate = useNavigate();

  // ----------------------------------------------------------------------
  // FUNCTIONS
  const handleSearch = () => {
    const params = {
      cageCode: filterCageCode,
      cageTypeId: selectedCageType,
      isOnline: filterIsOnline,
    };
    setSearchParam(params);
    setPage(0);
  };

  const handleFilterCageCode = (filterName) => {
    setFilterCageCode(filterName);
  };

  const handleFilterCageType = (selectedCageType) => {
    setSelectedCageType(selectedCageType);
  };

  const handleFilterIsOnline = (filterIsOnline) => {
    setFilterIsOnline(filterIsOnline);
  };

  const handleEditRow = (code) => {
    navigate(PATH_DASHBOARD.cage.edit(code));
  };

  const handleBanAdmin = async (id) => {
    await banCage(id);
    await getCageData();
  };

  const handleUnbanAdmin = async (id) => {
    await unbanCage(id);
    await getCageData();
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
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!filterCageCode) ||
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!filterIsOnline) ||
    (!(metadata.totalCount ? metadata.totalCount : 0) && !!selectedCageType);

  return (
    <>
      <Page title="Chuồng thú">
        <Container maxWidth={themeStretch ? false : 'lg'}>
          <HeaderBreadcrumbs
            heading="Danh sách chuồng thú"
            links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Danh sách chuồng thú' }]}
            action={
              <Button
                variant="contained"
                component={RouterLink}
                to={PATH_DASHBOARD.cage.new}
                startIcon={<Iconify icon={'eva:plus-fill'} />}
              >
                Thêm mới chuồng thú
              </Button>
            }
          />

          {/* Filter dữ liệu */}
          <CageTableToolbar
            onSearch={handleSearch}
            filterCageCode={filterCageCode}
            onFilterCageCode={handleFilterCageCode}
            cageTypes={cageTypes}
            selectedCageType={selectedCageType}
            onFilterCageType={handleFilterCageType}
            filterIsOnline={filterIsOnline}
            onFilterIsOnline={handleFilterIsOnline}
          />

          <Box mt={4} />

          <Card sx={{ p: 1 }}>
            {/* Scrollbar dùng để tạo scroll ngang cho giao diện điện thoại */}
            <Scrollbar>
              <TableContainer sx={{ minWidth: 800, position: 'relative' }}>
                <Table size={'medium'}>
                  <TableHeadCustom order={order} orderBy={orderBy} headLabel={TABLE_HEAD} onSort={onSort} />

                  <TableBody>
                    {tableData.map((row) => (
                      <CageTableRow
                        key={row.code}
                        row={row}
                        centerId={centerId}
                        onEditRow={() => handleEditRow(row.code)}
                        onDeleteRow={() => (row.status ? handleOpenBanDialog(row.code) : handleUnbanAdmin(row.code))}
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
      <DialogTitle>Bạn có chắc chắn muốn khóa thương hiệu?</DialogTitle>
      <DialogContent>
        <Typography variant="body2" sx={{ color: 'text.secondary' }}>
          Bạn vẫn có thể mở khóa thương hiệu này sau khi xác nhận!
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
