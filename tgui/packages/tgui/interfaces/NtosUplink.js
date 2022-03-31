import { NtosWindow } from '../layouts';
import { useBackend, useLocalState } from '../backend';
import { GenericUplink } from './Uplink';

export const NtosUplink = (props, context) => {
  const { data } = useBackend(context);
  const { telecrystals } = data;
  return (
    <NtosWindow
      width={700}
      height={580}
      theme="syndicate">
      <NtosWindow.Content>
        <div font-size="14">
          <GenericUplink
              currencyAmount={telecrystals}
              currencySymbol="TC" />
        </div>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
