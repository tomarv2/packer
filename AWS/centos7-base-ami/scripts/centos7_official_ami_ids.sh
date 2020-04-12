#!/bin/bash

aws --region us-west-2 ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=aw
