import { createBackend } from '@backstage/backend-defaults';
import { catalogPlugin } from '@backstage/plugin-catalog-backend';
import { Router } from 'express';
import { GithubOrgReaderProcessor } from '@backstage/plugin-catalog-backend-module-github';

interface PluginEnvironment {
  logger: any;
  config: any;
  database: any;
  permissions: any;
}

export default async function createPlugin(env: PluginEnvironment): Promise<Router> {
  const backend = createBackend();
  const catalog = backend.add(catalogPlugin());

  catalog.addProcessor(
    GithubOrgReaderProcessor.fromConfig(env.config, {
      logger: env.logger,
    })
  );

  await backend.start();
  const { router } = await catalog.build();
  return router;
}
