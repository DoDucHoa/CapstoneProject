// @mui
import { Stack, Skeleton, Box } from '@mui/material';

// ----------------------------------------------------------------------

export default function SkeletonBookingDetail() {
  return (
    <Stack spacing={1} direction="row" alignItems="center" sx={{ px: 3, py: 1.5 }}>
      <Stack spacing={1} sx={{ flexGrow: 1 }}>
        <Skeleton variant="text" sx={{ width: 0.25, height: 25, mb: 2 }} />
        <Skeleton variant="rectangular" sx={{ width: 0.25, height: 60 }} />
        <Box sx={{ my: 8 }} />
        <Skeleton variant="text" sx={{ width: 0.5, height: 25, mb: 2 }} />
        <Skeleton variant="text" sx={{ width: 0.5, height: 25, mb: 5 }} />
        <Box sx={{ my: 8 }} />
        <Skeleton variant="rectangular" sx={{ width: 1, height: 60 }} />
        <Box sx={{ my: 8 }} />
        <Skeleton variant="text" sx={{ width: 0.5, height: 25, mb: 2 }} />
        <Skeleton variant="text" sx={{ width: 0.5, height: 25, mb: 5 }} />
        <Box sx={{ my: 8 }} />
        <Skeleton variant="text" sx={{ width: 0.25, height: 25, mb: 2 }} />
        <Skeleton variant="text" sx={{ width: 0.1, height: 25, mb: 5 }} />
      </Stack>
    </Stack>
  );
}
