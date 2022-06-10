import React from 'react'

import ConnectWallet from '@/components/open/ConnectWallet'
import SetName from '@/components/open/SetName'
import OwnerPolicy from '@/components/open/OwnerPolicy'
import Review from '@/components/open/Review'
import { useRouter } from 'next/router'
import { TxStepperProps } from '@/components/tx/TxStepper/useTxStepper'
import VerticalTxStepper from '@/components/tx/TxStepper/vertical'

export type Owner = {
  name: string
  address: string
  resolving: boolean
}

export type CreateSafeFormData = {
  name: string
  threshold: number
  owners: Owner[]
}

export const CreateSafeSteps: TxStepperProps['steps'] = [
  {
    label: 'Connect wallet & select network',
    render: (data, onSubmit, onBack) => <ConnectWallet onSubmit={onSubmit} onBack={onBack} />,
  },
  {
    label: 'Name',
    render: (data, onSubmit, onBack) => <SetName onSubmit={onSubmit} onBack={onBack} />,
  },
  {
    label: 'Owners and Confirmations',
    render: (data, onSubmit, onBack) => (
      <OwnerPolicy params={data as CreateSafeFormData} onSubmit={onSubmit} onBack={onBack} />
    ),
  },
  {
    label: 'Review',
    render: (data, _, onBack) => <Review params={data as CreateSafeFormData} onBack={onBack} />,
  },
]

const CreateSafe = () => {
  const router = useRouter()

  return <VerticalTxStepper steps={CreateSafeSteps} onClose={() => router.push('/welcome')} />
}

export default CreateSafe
