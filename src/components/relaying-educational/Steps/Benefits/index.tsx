import { Box, Grid, SvgIcon, Typography } from '@mui/material'
import CheckIcon from '@/public/images/common/check.svg'
import { type StepRenderProps } from '@/components/relaying-educational/RelaySeriesStepper/useEducationSeriesStepper'
import Footer from '@/components/relaying-educational/Footer'

const Benefits = ({ onBack, onNext }: Partial<StepRenderProps>) => {
  return (
    <Box>
      <Grid container mb={5}>
        <Grid item xs={1}>
          <SvgIcon component={CheckIcon} sx={{ color: 'secondary.main' }} inheritViewBox />
        </Grid>
        <Grid item xs={11}>
          <Typography fontWeight={700}>Free 5 transactions per hour</Typography>
          <Typography color="label.secondary">
            We pay for your Safe transactions for up to five transactions per hour on Gnosis chain
          </Typography>
        </Grid>
      </Grid>
      <Grid container mb={5}>
        <Grid item xs={1}>
          <SvgIcon component={CheckIcon} sx={{ color: 'secondary.main' }} inheritViewBox />
        </Grid>
        <Grid item xs={11}>
          <Typography fontWeight={700}>Smooth execution</Typography>
          <Typography color="label.secondary">
            You can use your owner keys as &quot;throw-away accounts&quot; or &quot;signing-only accounts&quot; to make
            execution more smooth (e.g from your mobile device)
          </Typography>
        </Grid>
      </Grid>
      <Grid container mb={5}>
        <Grid item xs={1}>
          <SvgIcon component={CheckIcon} sx={{ color: 'secondary.main' }} inheritViewBox />
        </Grid>
        <Grid item xs={11}>
          <Typography fontWeight={700}>No fear of being the last in the process</Typography>
          <Typography color="label.secondary">
            You don’t have to distribute ETH (or other chain-specific native assets) amongst signer keys
          </Typography>
        </Grid>
      </Grid>
      <Footer back={{ label: 'Back', cb: onBack }} next={{ label: 'Next', cb: onNext }} />
    </Box>
  )
}

export default Benefits