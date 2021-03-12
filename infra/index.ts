import { k8s, pulumi, docker } from "@codegram/pulumi-utils";
import * as k from "@pulumi/kubernetes";
import * as kx from "@pulumi/kubernetesx";
import * as gcp from "@pulumi/gcp";
import * as random from "@pulumi/random";

/**
 * Get a reference to the stack that was used to create
 * the genesis Kubernetes cluster. In order to make it work you need to add
 * the `clusterStackRef` config value like this:
 *
 * $ pulumi config set clusterStackRef codegram/genesis-cluster/prod
 */
const stackReference = pulumi.getStackReference({
  name: pulumi.getValueFromConfig("clusterStackRef"),
});

const appsNamespace = stackReference.requireOutput("appsNamespaceName");

/**
 * Create a Kubernetes provider that will be used by all resources. This function
 * uses the previous `stackReference` outputs to create the provider for the
 * Genesis Kubernetes cluster.
 */
const kubernetesProvider = k8s.buildProvider({
  name: "decidim-staging",
  kubeconfig: stackReference.requireOutput("kubeconfig"),
  namespace: appsNamespace,
});

// DATABASE

export const dbPassword = pulumi.getSecretFromConfig(
  "dbPassword",
  "decidim-staging"
);

export const dbUserName = pulumi.getSecretFromConfig(
  "dbUserName",
  "decidim-staging"
);

export const db = new gcp.sql.DatabaseInstance("decidim-staging-db-instance",
  {
    databaseVersion: "POSTGRES_13",
    settings: {
      tier: "db-f1-micro",
      ipConfiguration: {
        authorizedNetworks: [{ value: "0.0.0.0/0" }],
      },
      databaseFlags: [{ name: "max_connections", value: "1000" }],
      backupConfiguration: {
        enabled: true
      }
    },
  },
  {
    additionalSecretOutputs: ["firstIpAddress"]
  }
);

const decidimStagingDatabase = new gcp.sql.Database("decidim-staging-db", {
  instance: db.name,
  name: "decidim-staging",
});

const dbUser = new gcp.sql.User("decidim-staging-db-instance-user", {
  instance: db.name,
  name: dbUserName,
  password: dbPassword,
});

/**
 * Create a new docker image. Use the `context` option to specify where
 * the `Dockerfile`is located.
 *
 * NOTE: to make this code work you need to add the following config value:
 *
 * $ pulumi config set gcpProjectId labs-260007
 *
 * The reason for that is we are pushing the docker images to Google cloud right now.
 */
//    value: pulumi.getSecretFromConfig("secretKeyBase", "decidim-staging"),
export const dbUrl = pulumi.interpolate`postgres://${dbUserName}:${dbPassword}@${db.firstIpAddress}:5432/decidim-staging`;

const dockerImage = docker.buildImage({
  name: "decidim-staging",
  context: "../",
  args: {
    DATABASE_URL: dbUrl,
    SECRET_KEY_BASE: pulumi.getSecretFromConfig(
      "secretKeyBase",
      "decidim-staging"
    ),
  },
});

const redisPassword = new random.RandomPassword(
  "decidim-staging-redis-password",
  {
    length: 16,
    special: false,
  }
);

const redisSecret = new kx.Secret(
  "decidim-staging-redis-secret",
  {
    stringData: {
      password: redisPassword.result,
    },
  },
  { provider: kubernetesProvider }
);

const redis = new k.helm.v3.Chart(
  "decidim-staging-redis",
  {
    path: "./redis",
    namespace: appsNamespace,
    values: {
      existingSecret: redisSecret.metadata.apply((m: any) => m.name),
      existingSecretPasswordKey: "password",
    },
  },
  { providers: { kubernetes: kubernetesProvider } }
);

const host: string = "staging.decidim.codegram.io";

const env: k.types.input.core.v1.EnvVar[] = [
  { name: "DECIDIM_HOST", value: host },
  { name: "DATABASE_URL", value: dbUrl },

  {
    name: "AWS_ACCESS_KEY_ID",
    value: pulumi.getSecretFromConfig("awsAccessKeyId", "decidim-staging"),
  },
  {
    name: "REDIS_URL",
    value: pulumi.interpolate`redis://default:${redisPassword.result}@decidim-staging-redis-master:6379`,
  },
  {
    name: "AWS_BUCKET_NAME",
    value: pulumi.getSecretFromConfig("awsBucketName", "decidim-staging"),
  },
  {
    name: "AWS_SECRET_ACCESS_KEY",
    value: pulumi.getSecretFromConfig("awsSecretAccessKey", "decidim-staging"),
  },
  {
    name: "EMAIL",
    value: pulumi.getSecretFromConfig("email", "decidim-staging"),
  },
  {
    name: "ETHERPAD_API_KEY",
    value: pulumi.getSecretFromConfig("etherpadApiKey", "decidim-staging"),
  },
  {
    name: "ETHERPAD_SERVER",
    value: pulumi.getSecretFromConfig("etherpadServer", "decidim-staging"),
  },
  {
    name: "GEOCODER_LOOKUP_APP_CODE",
    value: pulumi.getSecretFromConfig(
      "geocoderLookupAppCode",
      "decidim-staging"
    ),
  },
  {
    name: "GEOCODER_LOOKUP_APP_ID",
    value: pulumi.getSecretFromConfig("geocoderLookupAppId", "decidim-staging"),
  },
  {
    name: "HERE_API_KEY",
    value: pulumi.getSecretFromConfig("hereApiKey", "decidim-staging"),
  },
  {
    name: "HERE_APP_CODE",
    value: pulumi.getSecretFromConfig("hereAppCode", "decidim-staging"),
  },
  {
    name: "HERE_APP_ID",
    value: pulumi.getSecretFromConfig("hereAppId", "decidim-staging"),
  },
  { name: "LANG", value: pulumi.getValueFromConfig("lang", "decidim-staging") },
  {
    name: "MALLOC_ARENA_MAX",
    value: pulumi.getValueFromConfig("mallocArenaMax", "decidim-staging"),
  },
  {
    name: "MIN_THREADS",
    value: pulumi.getValueFromConfig("minThreads", "decidim-staging"),
  },
  {
    name: "RACK_ENV",
    value: pulumi.getValueFromConfig("rackEnv", "decidim-staging"),
  },
  {
    name: "RAILS_ENV",
    value: pulumi.getValueFromConfig("railsEnv", "decidim-staging"),
  },
  {
    name: "RAILS_LOG_TO_STDOUT",
    value: pulumi.getValueFromConfig("railsLogToStdout", "decidim-staging"),
  },
  {
    name: "RAILS_MAX_THREADS",
    value: pulumi.getValueFromConfig("railsMaxThreads", "decidim-staging"),
  },
  {
    name: "RAILS_SERVE_STATIC_FILES",
    value: pulumi.getValueFromConfig(
      "railsServeStaticFiles",
      "decidim-staging"
    ),
  },
  {
    name: "SECRET_KEY_BASE",
    value: pulumi.getSecretFromConfig("secretKeyBase", "decidim-staging"),
  },
  {
    name: "SENDGRID_PASSWORD",
    value: pulumi.getSecretFromConfig("sendgridPassword", "decidim-staging"),
  },
  {
    name: "SENDGRID_USERNAME",
    value: pulumi.getSecretFromConfig("sendgridUsername", "decidim-staging"),
  },
  {
    name: "SENTRY_DSN",
    value: pulumi.getSecretFromConfig("sentryDsn", "decidim-staging"),
  },
  {
    name: "SMTP_AUTHENTICATION",
    value: pulumi.getValueFromConfig("smtpAuthentication", "decidim-staging"),
  },
  {
    name: "SMTP_DOMAIN",
    value: pulumi.getValueFromConfig("smtpDomain", "decidim-staging"),
  },
  {
    name: "SMTP_PORT",
    value: pulumi.getValueFromConfig("smtpPort", "decidim-staging"),
  },
  {
    name: "WEB_CONCURRENCY",
    value: pulumi.getValueFromConfig("webConcurrency", "decidim-staging"),
  },
];

/*
  We define a job to run any DB migration we have.

  In the deployments, we'll add this job as a dependency. This way the system
  will check that this job has finished before actually deploying the new
  release.

  If we had a single deployment, we could move this to a `initContainer` step
  instead of being a separate job. This would simplify the build flow. But in
  this case we need a couple of deployments (srver & background job processing),
  so we want to make sure the DB is in the correct state before being able to
  start the deployments.
*/
const migrateJobName = "decidim-staging-migrate-job";
const migrateJob = new k.batch.v1.Job(
  migrateJobName,
  {
    spec: {
      template: {
        spec: {
          containers: [
            {
              name: migrateJobName,
              image: dockerImage.imageName,
              command: ["/bin/sh", "-c"],
              args: ["bin/rails db:migrate"], // https://stackoverflow.com/a/33888424/2110884
              env,
            },
          ],
          restartPolicy: "Never",
        },
      },
    },
  },
  { provider: kubernetesProvider }
);

/*
  We define a job to seed the DB.

  We're going to wait for the migrate job to finish before starting this one,
  but the deployment can start in parallel without any problem.
*/
const seedJobName = "decidim-staging-seed-job";
const seedJob = new k.batch.v1.Job(
  seedJobName,
  {
    spec: {
      template: {
        spec: {
          containers: [
            {
              name: seedJobName,
              image: dockerImage.imageName,
              command: ["/bin/sh", "-c"],
              args: ["bin/rails db:seed"], // https://stackoverflow.com/a/33888424/2110884
              env,
            },
          ],
          restartPolicy: "Never",
        },
      },
    },
  },
  {
    provider: kubernetesProvider,
    dependsOn: [migrateJob]
  }
);

/*
  We create a cron job to generate the metrics. It should run every day at 2AM
*/
const metricsCron = k8s.createCronjob({
  name: "decidim-staging-metrics-cron",
  schedule: "0 2 * * *",
  dockerImageName: dockerImage.imageName,
  command: ["bundle", "exec", "rake", "decidim:metrics:all"],
  env: env,
  provider: kubernetesProvider
});

/*
  We create a cron job to generate the open data files. It should run every day at 4AM
*/
const openDataCron = k8s.createCronjob({
  name: "decidim-staging-open-data-cron",
  schedule: "0 4 * * *",
  dockerImageName: dockerImage.imageName,
  command: ["bundle", "exec", "rake", "decidim:open_data:export"],
  env: env,
  provider: kubernetesProvider
});

const labels = { app: "decidim-staging" };

const deployment = new k.apps.v1.Deployment(
  `decidim-staging-deployment`,
  {
    spec: {
      selector: { matchLabels: labels },
      replicas: 2,
      strategy: {
        type: "RollingUpdate",
        rollingUpdate: {
          maxSurge: 2,
          maxUnavailable: 1,
        },
      },
      template: {
        metadata: { labels },
        spec: {
          containers: [
            {
              name: "decidim-staging-web",
              image: dockerImage.imageName,
              imagePullPolicy: "IfNotPresent",
              ports: [{ containerPort: 3000 }],
              command: ["bundle", "exec", "puma", "-C", "config/puma.rb"],
              env,
            },
          ],
        },
      },
    },
  },
  {
    provider: kubernetesProvider,
    dependsOn: [migrateJob]
  }
);

const service = new k.core.v1.Service(
  `decidim-staging-service`,
  {
    metadata: { labels },
    spec: {
      ports: [{ port: 80, targetPort: 3000 }],
      selector: labels,
    },
  },
  { provider: kubernetesProvider }
);

const ingress = new k.networking.v1beta1.Ingress(
  `decidim-staging-ingress`,
  {
    metadata: {
      labels,
      annotations: {
        "kubernetes.io/ingress.class": "nginx",
        "cert-manager.io/cluster-issuer": "letsencrypt-prod",
      },
    },
    spec: {
      tls: [{ hosts: [host], secretName: `decidim-staging-tls` }],
      rules: [
        {
          host,
          http: {
            paths: [
              {
                path: "/",
                backend: {
                  serviceName: service.metadata.name,
                  servicePort: 80,
                },
              },
            ],
          },
        },
      ],
    },
  },
  { provider: kubernetesProvider }
);

const workerLabels = { app: "decidim-staging-worker" };

/*
  We create a 2nd deployment that will hold the Sidekiq process.
*/
const workerDeployment = new k.apps.v1.Deployment(
  `decidim-staging-worker-deployment`,
  {
    spec: {
      selector: { matchLabels: workerLabels },
      replicas: 1,
      strategy: {
        type: "RollingUpdate",
        rollingUpdate: {
          maxSurge: 1,
          maxUnavailable: 0,
        },
      },
      template: {
        metadata: { labels: workerLabels },
        spec: {
          containers: [
            {
              name: "decidim-staging-worker",
              image: dockerImage.imageName,
              imagePullPolicy: "IfNotPresent",
              command: ["bundle", "exec", "sidekiq", "-e", "production", "-C", "config/sidekiq.yml"],
              env,
            },
          ],
        },
      },
    },
  },
  {
    provider: kubernetesProvider,
    dependsOn: [migrateJob]
  }
);

