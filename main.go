package main

import (
	"encoding/json"
	"fmt"

	"github.com/pulumi/pulumi-gcp/sdk/go/gcp/storage"
	"github.com/pulumi/pulumi/sdk/go/pulumi"
	"gopkg.in/resty.v1"
)

func createBucket(ctx *pulumi.Context, StorageClass string, Name string) (*storage.Bucket, error) {
	bucket, err := storage.NewBucket(ctx, Name, &storage.BucketArgs{
		ForceDestroy: true,
		StorageClass: StorageClass,
		Name:         Name,
	},
	)
	if err != nil {
		return bucket, err
	}
	return bucket, nil
}

//https://mholt.github.io/json-to-go/

type bucketsjson struct {
	Type string   `json:"type"`
	List []string `json:"list"`
}

func main() {

	pulumi.Run(func(ctx *pulumi.Context) error {
		resp, _ := resty.R().Get("http://api:8080/test")

		var buckets bucketsjson
		json.Unmarshal(resp.Body(), &buckets)
		//fmt.Printf("%v", buckets.Type)

		for _, item := range buckets.List {
			fmt.Printf("\n%v", item)
		}
		// Create a GCP resource (Storage Bucket) example extractig to a func
		for _, item := range buckets.List {
			//	fmt.Printf("%v", item)
			if _, err := createBucket(ctx, "COLDLINE", item); err != nil {
				return err
			}
		}

		return nil
	})
}
