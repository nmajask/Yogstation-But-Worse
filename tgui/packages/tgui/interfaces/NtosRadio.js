import { RadioContent } from './Radio';
import { NtosWindow } from '../layouts';

export const NtosRadio = (props, context) => {
  return (
    <NtosWindow
      width={325}
      height={300}>
      <NtosWindow.Content>
        <RadioContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
