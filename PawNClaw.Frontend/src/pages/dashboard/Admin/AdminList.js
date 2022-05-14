import { paramCase } from 'change-case';
import { useState, useEffect } from 'react';
import { Link as RouterLink, useNavigate } from 'react-router-dom';

// @mui
import {
  Box,
  Tab,
  Tabs,
  Card,
  Table,
  Button,
  Divider,
  TableBody,
  Container,
  TableContainer,
  TablePagination,
} from '@mui/material';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useTabs from '../../../hooks/useTabs';
import useSettings from '../../../hooks/useSettings';
import useTable, { emptyRows } from '../../../hooks/useTable';

// components
import Page from '../../../components/Page';
import Iconify from '../../../components/Iconify';
import Scrollbar from '../../../components/Scrollbar';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';

// sections
import { AdminTableRow, AdminTableToolbar } from '../../../sections/@dashboard/admin/list';

// API
import { getAdmins } from './getAdminData';

// ----------------------------------------------------------------------

const STATUS_OPTIONS = [
  { key: 0, value: '', label: 'All' },
  { key: 1, value: 'true', label: 'Active' },
  { key: 2, value: 'false', label: 'Banned' },
];

const TABLE_HEAD = [
  { id: 'name', label: 'Name', align: 'left' },
  { id: 'email', label: 'Email', align: 'left' },
  { id: 'phone', label: 'Phone Number', align: 'left' },
  { id: 'status', label: 'Status', align: 'left' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function UserList() {
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});

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

  const { currentTab: filterStatus, onChangeTab: onChangeFilterStatus } = useTabs('');

  useEffect(() => {
    const getAdminData = async () => {
      const response = await getAdmins(page, rowsPerPage, filterStatus);
      const { data, metadata } = response;

      const admins = data.map((admin, index) => ({
        id: admin.id,
        avatarUrl: `https://i.pravatar.cc/150?img=${index + 1}`,
        name: admin.name,
        email: admin.email,
        phoneNumber: admin.idNavigation.phone,
        status: admin.idNavigation.status,
      }));
      setTableData(admins);
      setMetadata(metadata);
    };
    getAdminData();
  }, [page, rowsPerPage, filterStatus]);

  const { themeStretch } = useSettings();

  const navigate = useNavigate();

  const [filterName, setFilterName] = useState('');

  const handleFilterName = (filterName) => {
    setFilterName(filterName);
    setPage(0);
  };

  const handleEditRow = (id) => {
    navigate(PATH_DASHBOARD.user.edit(paramCase(id)));
  };

  const denseHeight = 72;

  const isNotFound = (!metadata.totalCount && !!filterName) || (!metadata.totalCount && !!filterStatus);

  return (
    <Page title="Moderator: List">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Morderator List"
          links={[{ name: 'Dashboard', href: PATH_DASHBOARD.root }, { name: 'Morderator List' }]}
          action={
            <Button
              variant="contained"
              component={RouterLink}
              to={PATH_DASHBOARD.admin.new}
              startIcon={<Iconify icon={'eva:plus-fill'} />}
            >
              New Moderator
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
          <AdminTableToolbar filterName={filterName} onFilterName={handleFilterName} />

          {/* Scrollbar dùng để tạo scroll ngang cho giao diện điện thoại */}
          <Scrollbar>
            <TableContainer sx={{ minWidth: 800, position: 'relative' }}>
              <Table size={'medium'}>
                <TableHeadCustom order={order} orderBy={orderBy} headLabel={TABLE_HEAD} onSort={onSort} />

                <TableBody>
                  {tableData.map((row) => (
                    <AdminTableRow key={row.id} row={row} onEditRow={() => handleEditRow(row.name)} />
                  ))}

                  <TableEmptyRows height={denseHeight} emptyRows={emptyRows(page, rowsPerPage, metadata.totalCount)} />

                  <TableNoData isNotFound={isNotFound} />
                </TableBody>
              </Table>
            </TableContainer>
          </Scrollbar>

          <Box sx={{ position: 'relative' }}>
            <TablePagination
              rowsPerPageOptions={[5, 10, 15, 20]}
              component="div"
              count={metadata.totalCount}
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
