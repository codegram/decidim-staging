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

export const dbPassword = new random.RandomPassword(
  "decidim-staging-db-password",
  {
    length: 16,
    special: false,
  }
);

export const db = new gcp.sql.DatabaseInstance("decidim-staging-db-instance", {
  databaseVersion: "POSTGRES_9_6",
  settings: {
    tier: "db-f1-micro",
    ipConfiguration: {
      authorizedNetworks: [{ value: "0.0.0.0/0" }],
    },
    databaseFlags: [{ name: "max_connections", value: "1000" }],
  },
});

const decidimStagingDatabase = new gcp.sql.Database("decidim-staging-db", {
  instance: db.name,
  name: "decidim-staging",
});

const dbUser = new gcp.sql.User("decidim-staging-db-instance-user", {
  instance: db.name,
  name: "decidim-staging",
  password: dbPassword.result,
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
export const dbUrl = pulumi.interpolate`postgres://decidim-staging:${dbPassword.result}@${db.firstIpAddress}:5432/decidim-staging`;

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
          initContainers: [
            {
              name: "decidim-staging-migrate",
              image: dockerImage.imageName,
              imagePullPolicy: "IfNotPresent",
              command: ["bundle", "exec", "rake", "db:migrate"],
              env,
            },
          ],
          containers: [
            {
              name: "decidim-staging",
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
  { provider: kubernetesProvider }
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
