clean:
	rm -drf \
	.terraform \
	.terraform.lock.hcl \
	*.tfstate* \
	*.log 

fmt:
	terraform fmt -recursive
