import { SecurityConsoleMaintenance, SecurityConsoleRecord, SecurityConsoleRecordList } from './SecurityConsole';
import { NtosWindow } from '../layouts';

export const NtosSecurityRecords = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    screen } = data;
  const { theme = 'ntos' } = props;

  const [searchText, setSearchText] = useLocalState(context, "searchText", "");

  if (screen === "maint") {
    return (
      <NtosWindow resizable width={775} height={500} theme={PC_device_theme}>
        <NtosWindow.Content scrollable>
          <SecurityConsoleMaintenance />
        </NtosWindow.Content>
      </NtosWindow>
    );
  }

  if (screen === "record_view") {
    return (
      <NtosWindow resizable width={775} height={500} theme={PC_device_theme}>
        <NtosWindow.Content scrollable>
          <SecurityConsoleRecord />
        </NtosWindow.Content>
      </NtosWindow>
    );
  }

  return (
    <NtosWindow resizable width={775} height={500} theme={PC_device_theme}>
      <NtosWindow.Content scrollable>
          <SecurityConsoleRecordList />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
