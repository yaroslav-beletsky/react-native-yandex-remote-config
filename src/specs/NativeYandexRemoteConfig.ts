// its needed for codegen to work
import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type {
  Int32,
  Double,
  UnsafeObject,
} from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  initialize(apiKey: string, config: UnsafeObject): Promise<string>;
  activateConfig(): Promise<string>;
  fetchConfig(): Promise<string>;

  getString(key: string, defaultValue: string): Promise<string>;
  getInt(key: string, defaultValue: Int32): Promise<number>;
  getDouble(key: string, defaultValue: Double): Promise<number>;
  getBool(key: string, defaultValue: boolean): Promise<boolean>;

  getDeviceId(): Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('YandexRemoteConfig');
