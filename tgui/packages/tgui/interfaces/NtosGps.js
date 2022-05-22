import { GpsContent } from './Gps';
import { NtosWindow } from '../layouts';

export const NtosGps = (props, context) => {
  const { PC_device_theme } = data;
  return (
    <NtosWindow
      width={470}
      height={700}
      theme={PC_device_theme}>
      <NtosWindow.Content>
        <GpsContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
