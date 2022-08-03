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
import { CageTypeTableRow, CageTypeTableToolbar } from '../../../sections/@dashboard/cageType/list';

// API
import { getCageTypes, deleteCageType } from './useCageTypeAPI';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'name', label: 'Tên loại chuồng', align: 'left' },
  { id: 'height', label: 'Chiều cao (cm)', align: 'right' },
  { id: 'width', label: 'Chiều rộng (cm)', align: 'right' },
  { id: 'length', label: 'Chiều dài (cm)', align: 'right' },
  { id: 'isSingle', label: 'Chuồng riêng', align: 'center' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function CageTypeList() {
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});
  const [filterName, setFilterName] = useState('');
  const [searchRequest, setSearchRequest] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectIdCageType, setSelectIdCageType] = useState();

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

  const getCageTypeData = async () => {
    const response = await getCageTypes(centerId, page, rowsPerPage, searchRequest);

    const { data, metadata } = response;

    const cageTypes = data.map((cageType) => ({
      id: cageType.id,
      name: cageType.typeName,
      height: cageType.height,
      width: cageType.width,
      length: cageType.length,
      isSingle: cageType.isSingle,
      photoUrl: cageType?.photos?.length > 0 ? cageType?.photos[0].url : '',
      status: cageType.status,
    }));

    setTableData(cageTypes);
    setMetadata(metadata);
  };

  useEffect(() => {
    getCageTypeData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [centerId, page, rowsPerPage, searchRequest]);

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

  const handleDeleteCageType = async (id) => {
    await deleteCageType(id);
    await getCageTypeData();
  };

  const handleOpenDeleteCageTypeDialog = (idCageType) => {
    setSelectIdCageType(idCageType);
    setOpenDialog(true);
  };

  const handleCloseDeleteCageTypeDialog = () => {
    setOpenDialog(false);
  };

  const denseHeight = 72;

  const isNotFound = !(metadata.totalCount ? metadata.totalCount : 0) && !!filterName;

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
                        onDeleteRow={() => handleOpenDeleteCageTypeDialog(row.id)}
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
      <DeleteCageTypeDialog
        open={openDialog}
        onClose={handleCloseDeleteCageTypeDialog}
        idCageType={selectIdCageType}
        handleDeleteCageType={handleDeleteCageType}
      />
    </>
  );
}

// ----------------------------------------------------------------------
DeleteCageTypeDialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
  idCageType: PropTypes.number,
  handleDeleteCageType: PropTypes.func,
};

function DeleteCageTypeDialog({ open, onClose, idCageType, handleDeleteCageType }) {
  const onConfirm = () => {
    handleDeleteCageType(idCageType);
    onClose();
  };

  return (
    <Dialog open={open} maxWidth="xs" onClose={onClose}>
      <DialogTitle>Bạn có chắc chắn muốn xóa?</DialogTitle>
      <DialogContent>
        <Typography variant="body2" sx={{ color: 'text.secondary' }}>
          Bạn không thể khôi phục lại nếu đã xóa!
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
