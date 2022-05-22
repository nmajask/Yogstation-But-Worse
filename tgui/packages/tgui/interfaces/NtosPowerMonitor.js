import { NtosWindow } from '../layouts';
import { PowerMonitorContent } from './PowerMonitor';

export const NtosPowerMonitor = () => {
  const { PC_device_theme } = data;
  return (
    <NtosWindow
      width={550}
      height={700}
      theme={PC_device_theme}
      resizable>
      <NtosWindow.Content scrollable>
        <PowerMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
