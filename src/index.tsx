import type { Settings, ValueType } from './types';
import { FlagType } from './types';
import NativeYandexRemoteConfig from './specs/NativeYandexRemoteConfig';

class YandexRemoteConfigClass {
  public getDeviceId = (): Promise<string> =>
    NativeYandexRemoteConfig.getDeviceId();

  public init = (apiKey: string, config?: Settings): Promise<string> =>
    NativeYandexRemoteConfig.initialize(apiKey, config || {});

  public activateConfig = (): Promise<string> =>
    NativeYandexRemoteConfig.activateConfig();

  public fetchConfig = (): Promise<string> =>
    NativeYandexRemoteConfig.fetchConfig();

  public get = async <S extends FlagType, T extends ValueType<S>>(
    key: string,
    type: FlagType,
    defaultValue?: T
  ): Promise<T> => {
    try {
      switch (type) {
        case FlagType.string: {
          return (await NativeYandexRemoteConfig.getString(
            key,
            `${defaultValue ?? ''}`
          )) as T;
        }
        case FlagType.int: {
          return (await NativeYandexRemoteConfig.getInt(
            key,
            Number(defaultValue ?? 0)
          )) as T;
        }
        case FlagType.double: {
          return (await NativeYandexRemoteConfig.getDouble(
            key,
            Number(defaultValue ?? 0)
          )) as T;
        }
        case FlagType.bool: {
          return (await NativeYandexRemoteConfig.getBool(
            key,
            Boolean(defaultValue ?? false)
          )) as T;
        }
      }
    } catch (e) {
      throw e;
    }
  };
}

export const YandexRemoteConfig = new YandexRemoteConfigClass();

export * from './types';
export * from './utils';
export * from './hooks';
