import { ExosuitControlConsoleContent } from './ExosuitControlConsole';
import { NtosWindow } from '../layouts';

export const NtosExosuitControl = (props, context) => {
  const { PC_device_theme } = data;
  return (
    <NtosWindow
      width={470}
      height={700}
      theme={PC_device_theme}>
      <NtosWindow.Content>
        <ExosuitControlConsoleContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
