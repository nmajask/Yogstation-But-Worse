import { CargoBountyContent } from './CargoBountyConsole.js';
import { NtosWindow } from '../layouts';

export const NtosCargoBounties = (props, context) => {
  return (
    <NtosWindow
      width={750}
      height={600}
      resizable>
      <NtosWindow.Content scrollable>
        <CargoBountyContent fontSize={1.25}/>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
