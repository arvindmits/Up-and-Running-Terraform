# Terratest

+ p. 235: dep init
+ p. 237: dep ensure -add github.com/gruntwork-io/terratest/modules/terraform@v0.15.9
+ p. 239: dep ensure

Basic Terratest:
+ go test -v -timeout 30m -run ThisTest

or

+  go test -v -timeout 30m
   + Note: add t.Parallel() in code to run tests in parallel
```
package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestAlbExample(t *testing.T)  {

	t.Parallel()

	opts := &terraform.Options{
		// You should update this relative path to point at your alb
		// example directory!
		TerraformDir: "../examples/alb",

		Vars: map[string]interface{}{
			"alb_name": fmt.Sprintf("test-%s", random.UniqueId()),
		},

	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)

	// Deploy the example
	terraform.InitAndApply(t, opts)

	// Get the URL of the ALB
	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	// Test that the ALB's default action is working and returns a 404

	expectedStatus := 404
	expectedBody := "404: page not found"

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetry(
		t,
		url,
		expectedStatus,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)

}
```

Note with multiple people running same test or test in parallel test will fail with common name. To fix the problem:
```
		Vars: map[string]interface{}{
			"alb_name": fmt.Sprintf("test-%s", random.UniqueId()),
		},
```

> Important: State file can get overwritten when using backend so use backend.hcl file when using staging and for testing you tell Terratest to pass in test-time-friendly values using the BackendConfig parameter of terraform.options (pg. 264). Note: use of random (id) number below

```
	uniqueId := random.UniqueId()

	bucketForTesting := GetRequiredEnvVar(t, TerraformStateBucketForTestEnvVarName)
	bucketRegionForTesting := GetRequiredEnvVar(t, TerraformStateRegionForTestEnvVarName)

	dbStateKey := fmt.Sprintf("%s/%s/terraform.tfstate", t.Name(), uniqueId)

	return &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]interface{}{
			"db_name": fmt.Sprintf("test%s", uniqueId),
			"db_password": "password",
		},

		BackendConfig: map[string]interface{}{
			"bucket":         bucketForTesting,
			"region":         bucketRegionForTesting,
			"key":            dbStateKey,
			"encrypt":        true,
		},
	}
```

# Intergration Test

pg. 259: Skimmed section

## Test stages

pg. 266: skimmed, enhanced integration test

# End-to-End Tests

pg. 273: skimmed


# Video Version

Video: https://www.infoq.com/presentations/automated-testing-terraform-docker-packer/

GitHub: https://github.com/gruntwork-io/infrastructure-as-code-testing-talk/tree/master/test

