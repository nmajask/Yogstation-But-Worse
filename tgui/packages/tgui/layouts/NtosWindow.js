/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Button, Modal, Icon, Flex } from '../components';
import { Window } from './Window';

export const NtosWindow = (props, context) => {
  const {
    title,
    width = 575,
    height = 700,
    resizable,
    theme = 'ntos',
    children,
  } = props;
  const { act, data } = useBackend(context);
  const {
    Prg_Error,
  } = data;

  if (Prg_Error) {
    return (
      <Window
        title={title}
        width={width}
        height={height}
        theme={theme}
        resizable={resizable}>
      <div className="NtosWindow">
        <NtosWindowHeader />
        <NtosWindowError />
      </div>
    </Window>
    );
  };
  return (
    <Window
      title={title}
      width={width}
      height={height}
      theme={theme}
      resizable={resizable}>
      <div className="NtosWindow">
        <NtosWindowHeader />
        {children}
      </div>
    </Window>
  );
};

const NtosWindowHeader = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    PC_device_theme,
    PC_batteryicon,
    PC_showbatteryicon,
    PC_batterypercent,
    PC_ntneticon,
    PC_apclinkicon,
    PC_stationtime,
    PC_programheaders = [],
    PC_showexitprogram,
  } = data;
  return (
    <Fragment>
      <div className="NtosWindow__header NtosHeader">
          <div className="NtosHeader__left">
            <Box inline bold mr={2}>
              {PC_stationtime}
            </Box>
            <Box inline italic mr={2} opacity={0.33}>
              {PC_device_theme === 'ntos' && 'NtOS'}
              {PC_device_theme === 'syndicate' && 'Syndix'}
              {PC_device_theme === 'abductor' && 'Abductorware'}
            </Box>
          </div>
          <div className="NtosHeader__right">
            {PC_programheaders.map(header => (
              <Box key={header.icon} inline mr={1} tooltip={header.tooltip} tooltipPosition="bottom">
                <img
                  className="NtosHeader__icon"
                  src={resolveAsset(header.icon)} />
              </Box>
            ))}
            <Box inline>
              {PC_ntneticon && (
                <img
                  className="NtosHeader__icon"
                  src={resolveAsset(PC_ntneticon)} />
              )}
            </Box>
            {!!PC_showbatteryicon && PC_batteryicon && (
              <Box inline mr={1}>
                {PC_batteryicon && (
                  <img
                    className="NtosHeader__icon"
                    src={resolveAsset(PC_batteryicon)} />
                )}
                {PC_batterypercent && (
                  PC_batterypercent
                )}
              </Box>
            )}
            {PC_apclinkicon && (
              <Box inline mr={1}>
                <img
                  className="NtosHeader__icon"
                  src={resolveAsset(PC_apclinkicon)} />
              </Box>
            )}
            {!!PC_showexitprogram && (
              <Button
                width="26px"
                lineHeight="22px"
                textAlign="center"
                color="transparent"
                icon="window-minimize-o"
                tooltip="Minimize"
                tooltipPosition="bottom"
                onClick={() => act('PC_minimize')} />
            )}
            {!!PC_showexitprogram && (
              <Button
                mr="-3px"
                width="26px"
                lineHeight="22px"
                textAlign="center"
                color="transparent"
                icon="window-close-o"
                tooltip="Close"
                tooltipPosition="bottom-left"
                onClick={() => act('PC_exit')} />
            )}
            {!PC_showexitprogram && (
              <Button
                mr="-3px"
                width="26px"
                lineHeight="22px"
                textAlign="center"
                color="transparent"
                icon="power-off"
                tooltip="Power off"
                tooltipPosition="bottom-left"
                onClick={() => act('PC_shutdown')} />
            )}
          </div>
        </div>
    </Fragment>
  );
};

const NtosWindowError = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    Prg_ErrorName,
    Prg_ErrorDesc,
    Prg_ErrorIcon,
  } = data;
  return (
    <Fragment>
      <div className="NtosWindow__content" align="center">
        <Modal>
          <Icon name={Prg_ErrorIcon ? Prg_ErrorIcon : "exclamation-triangle"}
            verticalAlign="middle"
            size="6"/>
          <Box fontSize="16px" bold>{Prg_ErrorName ? Prg_ErrorName : "UNKNOWN ERROR"}</Box>
          <Box fontSize="10px">{Prg_ErrorDesc ? Prg_ErrorDesc : "An unknown error has occered, If problem persists contact your system administrator."}</Box>
          <Flex align="center">
            <Flex.Item >
              <Button
                width="52px"
                lineHeight="22px"
                color="transparent"
                icon="window-minimize-o"
                tooltip="Minimize"
                tooltipPosition="bottom"
                onClick={() => act('PC_minimize')} />
            </Flex.Item>
            <Flex.Item>
              <Button
                mr="-3px"
                width="52px"
                lineHeight="22px"
                color="transparent"
                icon="window-close-o"
                tooltip="Close"
                tooltipPosition="bottom-left"
                onClick={() => act('PC_exit')} />
            </Flex.Item>
            <Flex.Item>
              <Button
                mr="-3px"
                width="52px"
                lineHeight="22px"
                color="transparent"
                icon="power-off"
                tooltip="Power off"
                tooltipPosition="bottom-left"
                onClick={() => act('PC_shutdown')} />
            </Flex.Item>
          </Flex>
        </Modal>
      </div>
    </Fragment>
  );
};

const NtosWindowContent = props => {
  return (
    <div className="NtosWindow__content">
      <Window.Content {...props} />
    </div>
  );
};

NtosWindow.Content = NtosWindowContent;
NtosWindow.Error = NtosWindowError;
