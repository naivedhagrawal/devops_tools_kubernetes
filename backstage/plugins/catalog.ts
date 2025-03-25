import { createRouter } from '@backstage/plugin-catalog-backend';
import { PluginEnvironment } from '../types';
import { GithubOrgReaderProcessor } from '@backstage/plugin-catalog-backend-module-github';

export default async function createPlugin(env: PluginEnvironment) {
  const builder = await createRouter(env);

  // Add the GitHub Org Reader Processor
  builder.catalogBuilder.addProcessor(
    GithubOrgReaderProcessor.fromConfig(env.config, {
      logger: env.logger,
      schedule: env.scheduler,
      reader: env.reader,
    })
  );

  return builder;
}
