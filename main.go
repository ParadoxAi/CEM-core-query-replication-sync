package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"sync"
	"syscall"
)

func main() {
	/*
		FKN ARGH! ... slowly working through these

		TODO: 1. this is using v1 AWS SDK
		      2. DB handling allows connection draining and does not refresh
			  3. add MT4-CN2-L and later the second ROW server - done
			  4. waaay over-complicated type management - underway
			  5. DB and AWS API calls do not use contexts - underway
			  6. what happens if something goes wrong during initialization?
			  7. methods should return errors - underway
			  8. error handling is over-engineered - underway
			  9. some methods return redundant values - underway
			 10. it's not clear what all these delays do - done
			 11. Go switch is very powerful and more readable ... switch instead of else if FFS - underway
			 12. comments that are wrong or misleading are worse than no comments at all - underway
			 13. not understanding how fmt.* works (creating your own field spacing) - underway
			 14. packages are helpful
	*/
	ssmClt := NewSSMClient()
	dvCfg := GetDbCfg(ssmClt, "/prod/dv-sync")
	dvRoCfg := GetDbCfg(ssmClt, "/prod/dv-sync-ro")

	dblist := []MtDbName{mt4lCny, mt4lCny2, mt4lRow, mt4lBb, mt5l, mt5lBb, mt5lFcs}

	dbw, err := NewMySQLConnection(dvCfg)
	LogErr(err, "main ")
	dbr, err := NewMySQLConnection(dvRoCfg)
	LogErr(err, "main ")
	fmt.Println("sync is starting up")

	ctx, fnc := context.WithCancel(context.Background())

	// allow container to gracefully shut down:

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		s := <-interrupt
		fmt.Printf("received signal %s\n", s)
		fnc()
	}()

	wg := sync.WaitGroup{}

	wg.Add(1)

	go func() {
		for ctx.Err() == nil {
			for _, dbname := range dblist {
				// if dbname == mt4lCny {
				// 	continue
				// }

				fmt.Println("processing accounts for", dbname)

				if err := SyncAccount(ctx, dbw, dbr, dbname); err != nil {
					LogMsgErr(MsgErr{syncAccFail, err})
				}

				if ctx.Err() != nil {
					break
				}
			}
		}
	}()

	//wg.Add(1)
	//
	//go func() {
	//	for ctx.Err() == nil {
	//		for _, dbname := range dblist {
	//			fmt.Println("processing trades for", dbname)
	//
	//			if err := SyncTrades(dbname, dbw, dbr); err != nil {
	//				LogMsgErr(MsgErr{syncTradesFail, err})
	//			}
	//
	//			if ctx.Err() != nil {
	//				break
	//			}
	//		}
	//	}
	//}()

	wg.Wait()

	if ctx.Err() != nil {
		fmt.Println(ctx.Err())
	}

	fmt.Println("sync stopped")
}
