import PropTypes from 'prop-types';
import { Grid, TextField, Card, MenuItem, Button } from '@mui/material';

// ----------------------------------------------------------------------

CageTableToolbar.propTypes = {
  filterCageCode: PropTypes.string,
  onFilterCageCode: PropTypes.func,
  cageTypes: PropTypes.array,
  onSearch: PropTypes.func,
  selectedCageType: PropTypes.number,
  onFilterCageType: PropTypes.func,
  filterIsOnline: PropTypes.number,
  onFilterIsOnline: PropTypes.func,
};

export default function CageTableToolbar({
  onSearch,
  filterCageCode,
  onFilterCageCode,
  cageTypes,
  selectedCageType,
  onFilterCageType,
  filterIsOnline,
  onFilterIsOnline,
}) {
  return (
    <Card sx={{ p: 3 }}>
      <Grid container spacing={3}>
        <Grid item xs={6} md={4}>
          <TextField
            value={filterCageCode}
            onChange={(e) => onFilterCageCode(e.target.value)}
            label="Tìm theo mã chuồng"
            fullWidth
          />
        </Grid>
        <Grid item xs={6} md={4}>
          <TextField
            value={selectedCageType}
            onChange={(e) => onFilterCageType(e.target.value)}
            defaultValue={0}
            label="Loại chuồng"
            select
            fullWidth
            SelectProps={{ native: false }}
            InputLabelProps={{ shrink: true }}
          >
            <MenuItem
              key={0}
              value={0}
              sx={{
                mx: 1,
                my: 0.5,
                borderRadius: 0.75,
                typography: 'body2',
                textTransform: 'capitalize',
              }}
            >
              Tất Cả
            </MenuItem>
            {cageTypes.map((cageType) => (
              <MenuItem
                key={cageType.id}
                value={cageType.id}
                sx={{
                  mx: 1,
                  my: 0.5,
                  borderRadius: 0.75,
                  typography: 'body2',
                  textTransform: 'capitalize',
                }}
              >
                {cageType.typeName}
              </MenuItem>
            ))}
          </TextField>
        </Grid>
        <Grid item xs={12} md={2}>
          <TextField
            value={filterIsOnline}
            onChange={(e) => onFilterIsOnline(e.target.value)}
            select
            fullWidth
            label="Trạng thái"
            SelectProps={{ native: false }}
            InputLabelProps={{ shrink: true }}
          >
            <MenuItem
              key={3}
              value={3}
              sx={{
                mx: 1,
                my: 0.5,
                borderRadius: 0.75,
                typography: 'body2',
                textTransform: 'capitalize',
              }}
            >
              Tất Cả
            </MenuItem>
            <MenuItem
              key={1}
              value={1}
              sx={{
                mx: 1,
                my: 0.5,
                borderRadius: 0.75,
                typography: 'body2',
                textTransform: 'capitalize',
              }}
            >
              Online
            </MenuItem>
            <MenuItem
              key={0}
              value={0}
              sx={{
                mx: 1,
                my: 0.5,
                borderRadius: 0.75,
                typography: 'body2',
                textTransform: 'capitalize',
              }}
            >
              Offline
            </MenuItem>
          </TextField>
        </Grid>
        <Grid item xs={12} md={2} sx={{ alignSelf: 'center' }}>
          <Button variant="contained" color="primary" fullWidth size="large" onClick={onSearch}>
            Tìm kiếm
          </Button>
        </Grid>
      </Grid>
    </Card>
  );
}
