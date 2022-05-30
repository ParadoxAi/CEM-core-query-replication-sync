package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/go-sql-driver/mysql"
)

// SqlErrCode returns 0 if err not a MySQL err
func SqlErrCode(err error) uint16 {
	if err != nil {
		me, ok := err.(*mysql.MySQLError)
		if !ok {
			return 0
		}
		return me.Number
	}
	return 0
}

// SlackAlert alerts Slack
func SlackAlert(err error, msg string) {
	if e := SendSlackNotification(slackSync, fmt.Sprintf("%s\n`%v`", msg, err)); e != nil {
		fmt.Println("Slack alert failed", e)
	}
}

// LogErr Use for FATAL Issue. Alerts Slack.
func LogErr(err error, msg string) {
	if err == nil {
		return
	}

	if SqlErrCode(err) == 1048 {
		LogMsgErr(MsgErr{deadlockFound, err})
		return
	}
	err2 := SendSlackNotification(slackSync, fmt.Sprintf("%s\n`%v`", msg, err))
	fmt.Printf("%+v\n", err)
	if err2 != nil {
		log.Println(err2, err)
	}
}

// LogMsgErr returns message and error. It alerts Slack.
func LogMsgErr(err MsgErr) {
	if err.err == nil {
		return
	}

	err2 := SendSlackNotification(slackSync, fmt.Sprintf("%s\n`%v`", err.msg, err.err))

	fmt.Println(err.msg)
	fmt.Println(err.err)
	if err2 != nil {
		log.Println(err2, err)
	}
}

// SendSlackNotification will post to an 'Incoming Webhook' url setup in Slack Apps. It accepts
// some text and the Slack channel is saved within Slack.
func SendSlackNotification(webhookUrl SlackUrl, msg string) error {
	slackBody, err := json.Marshal(SlackRequestBody{Text: msg})
	if err != nil {
		return err
	}

	req, err := http.NewRequest(http.MethodPost, string(webhookUrl), bytes.NewBuffer(slackBody))
	if err != nil {
		return err
	}

	req.Header.Add("Content-Type", "application/json")

	rsp, err := http.DefaultClient.Do(req)
	if err != nil {
		return err
	}

	if err != nil {
		return err
	}

	defer rsp.Body.Close()

	if rsp.StatusCode < 202 {
		return nil
	}

	var rmsg string

	bs, err := ioutil.ReadAll(rsp.Body)
	if err != nil {
		rmsg = err.Error()
	} else {
		rmsg = string(bs)
	}

	return fmt.Errorf("http %d %s", rsp.StatusCode, rmsg)
}
