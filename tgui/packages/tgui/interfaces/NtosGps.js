import { GpsContent } from './Gps';
import { NtosWindow } from '../layouts';

export const NtosGps = (props, context) => {
  return (
    <NtosWindow
      width={470}
      height={700}>
      <NtosWindow.Content>
        <GpsContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
