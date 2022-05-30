package main

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ssm"
	"log"
)

func Sessions() (*session.Session, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("ap-southeast-2"),
	})

	svc := session.Must(sess, err)
	return svc, err
}

func NewSSMClient() *SSM {
	// Create AWS Session
	sess, err := Sessions()
	if err != nil {
		log.Println(err)
		return nil
	}
	ssmsvc := &SSM{ssm.New(sess)}
	// Return SSM client
	return ssmsvc
}

func (s *SSM) Param(name string, decryption bool) *Param {
	return &Param{
		Name:           name,
		WithDecryption: decryption,
		ssmsvc:         s,
	}
}

func (p *Param) GetValue() (string, error) {
	ssmsvc := p.ssmsvc.client
	parameter, err := ssmsvc.GetParameter(&ssm.GetParameterInput{
		Name:           &p.Name,
		WithDecryption: &p.WithDecryption,
	})
	if err != nil {
		return "", err
	}
	value := *parameter.Parameter.Value
	return value, nil
}
